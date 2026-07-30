#!/usr/bin/env python3
r"""Create a markdown table of content as a nested list of links

Markdown editors such as the ones in OneDrive, Teams or Word Online have no
table of content plugin. This script reads a markdown file, extracts its ATX
headings (the ones starting with `#`) and prints a nested list of links that
can be pasted at the top of the document. Anchors follow the GitHub slug
convention, which also works in Word Online:

    - [Section One](#section-one)

Print the table of content to the screen:

    cd ~/rp/paulrougieux.github.io/scripts
    python md_toc.py ../python.Rmd

Edit a file in place, inserting the table of content just after the YAML front
matter. Test it on a dummy file with two titles:

    cd ~/rp/paulrougieux.github.io/scripts
    mkdir -p /tmp/toc
    printf -- '---\ntitle: "Dummy"\n---\n\n# Section One\n\ntext\n\n# Section Two\n\nmore text\n' > /tmp/toc/dummy.md
    python md_toc.py --in-place /tmp/toc/dummy.md
    edited /tmp/toc/dummy.md

The file now starts with the front matter, then the table of content, then the
original text:

    cat /tmp/toc/dummy.md
    ---
    title: "Dummy"
    ---

    <!-- toc -->
    - [Section One](#section-one)
    - [Section Two](#section-two)
    <!-- /toc -->

    # Section One

    text

    # Section Two

    more text

Running it again replaces the content between the markers, so the table of
content is not duplicated.

Write a copy of the document with the table of content inserted after the YAML
front matter, together with an HTML rendering used to check that the links
work:

    python md_toc.py ../python.Rmd -o /tmp/toc/ --html
    wrote /tmp/toc/python.Rmd
    wrote /tmp/toc/python.html

Then open /tmp/toc/python.html in a browser and click a few links to check
that they jump to the corresponding sections:

    firefox /tmp/toc/python.html

The HTML is rendered by pandoc with the `gfm` reader, so that the heading
identifiers in the HTML follow the same slug convention as the links in the
table of content.

The table of content is surrounded by `<!-- toc -->` and `<!-- /toc -->`
markers. When those markers are already present in the input file, the content
between them is replaced, so the script can be run again on its own output.

Headings inside the YAML front matter and inside fenced code blocks are
ignored. Only ATX headings are recognised, titles underlined with `=====` or
`-----` are not. The default depth is level 1 to 3, because deeper levels
make the list too long to be useful, see --min-level and --max-level.

Run the examples in the docstrings with:

    python -m doctest md_toc.py -v

"""

import argparse
import re
import subprocess
import sys
from pathlib import Path

HEADING = re.compile(r"^ {0,3}(?P<hashes>#{1,6})[ \t]+(?P<title>.*?)[ \t]*#*[ \t]*$")
FENCE = re.compile(r"^ {0,3}(?P<fence>`{3,}|~{3,})")
LINK = re.compile(r"!?\[(?P<text>[^]]*)\]\([^)]*\)")
BEGIN_MARKER = "<!-- toc -->"
END_MARKER = "<!-- /toc -->"


def heading_text(title):
    """Return the plain text of a heading title, as a reader would see it

    Markdown links are replaced by their text, because a link nested in
    another link is not valid markdown. Emphasis and code markers are removed.

    Parameters
    ----------
    title : str
        Heading title as written in the markdown file, without the leading
        hashes.

    Returns
    -------
    str
        Heading title without markdown markup.

    Example
    -------
    >>> heading_text("Install with **pip**")
    'Install with pip'
    >>> heading_text("See [the pip page](https://pypi.org/project/pip/)")
    'See the pip page'
    >>> heading_text("`__init__.py`")
    '__init__.py'

    """
    text = LINK.sub(lambda match: match.group("text"), title)
    text = text.replace("`", "").replace("**", "").replace("*", "")
    return text.strip()


def slugify(text):
    """Convert a heading text to a GitHub style anchor slug

    The text is lower cased, everything that is not a letter, a digit, a space,
    an underscore or a hyphen is removed, then spaces become hyphens.

    Parameters
    ----------
    text : str
        Plain text of the heading, as returned by `heading_text`.

    Returns
    -------
    str
        Anchor slug, without the leading `#`.

    Example
    -------
    >>> slugify("Install with Pip")
    'install-with-pip'
    >>> slugify("Discussion pip, conda, apt")
    'discussion-pip-conda-apt'
    >>> slugify("__init__.py")
    '__init__py'

    """
    slug = text.lower()
    slug = re.sub(r"[^\w\s-]", "", slug, flags=re.UNICODE)
    slug = re.sub(r"\s+", "-", slug.strip())
    return slug


def find_headings(lines, min_level=1, max_level=3):
    """Find the headings of a markdown document

    Skip the YAML front matter and the content of fenced code blocks. Slugs are
    made unique by appending `-1`, `-2` and so on to duplicates, the way GitHub
    does. Note that headings outside of the requested level range still count
    for that numbering, because the anchors they generate exist in the rendered
    document.

    Parameters
    ----------
    lines : list of str
        Lines of the markdown document, without the line endings.
    min_level : int
        Shallowest heading level to keep, 1 for `#`.
    max_level : int
        Deepest heading level to keep, 3 for `###`.

    Returns
    -------
    list of tuple
        One `(level, text, slug)` tuple per heading in the level range.

    Example
    -------
    >>> find_headings(["# Title", "", "## Section One", "### Deep", "## Title"])
    [(1, 'Title', 'title'), (2, 'Section One', 'section-one'), (3, 'Deep', 'deep'), (2, 'Title', 'title-1')]
    >>> find_headings(["# Title", "```", "# Not a heading", "```"])
    [(1, 'Title', 'title')]

    """
    headings = []
    slug_count = {}
    fence = None
    start = 0
    if lines and lines[0].strip() == "---":
        for number, line in enumerate(lines[1:], start=1):
            if line.strip() in ("---", "..."):
                start = number + 1
                break
    for line in lines[start:]:
        opening = FENCE.match(line)
        if fence is not None:
            # Inside a fenced code block, only a fence of the same character
            # and at least as long closes it.
            if opening and opening.group("fence")[0] == fence[0]:
                if len(opening.group("fence")) >= len(fence):
                    fence = None
            continue
        if opening:
            fence = opening.group("fence")
            continue
        match = HEADING.match(line)
        if not match:
            continue
        level = len(match.group("hashes"))
        text = heading_text(match.group("title"))
        if not text:
            continue
        slug = slugify(text)
        count = slug_count.get(slug, 0)
        slug_count[slug] = count + 1
        if count:
            slug = f"{slug}-{count}"
        if min_level <= level <= max_level:
            headings.append((level, text, slug))
    return headings


def build_toc(headings, indent=2):
    """Build the markdown table of content from a list of headings

    Headings are indented relative to the shallowest heading present, so that
    the list is not needlessly indented when the document has no level 1
    heading.

    Parameters
    ----------
    headings : list of tuple
        `(level, text, slug)` tuples, as returned by `find_headings`.
    indent : int
        Number of spaces per heading level.

    Returns
    -------
    str
        The table of content, one markdown list item per line.

    Example
    -------
    >>> print(build_toc([(2, "One", "one"), (3, "Deep", "deep")]))
    - [One](#one)
      - [Deep](#deep)

    """
    if not headings:
        return ""
    base = min(level for level, _, _ in headings)
    items = [
        f"{' ' * (indent * (level - base))}- [{text}](#{slug})"
        for level, text, slug in headings
    ]
    return "\n".join(items)


def insert_toc(text, toc):
    """Insert the table of content into the text of a markdown document

    The table of content is surrounded by the `<!-- toc -->` and `<!-- /toc -->`
    markers. When those markers are already there, what lies between them is
    replaced. Otherwise the table of content is inserted after the YAML front
    matter, or at the top of the document when there is no front matter.

    Parameters
    ----------
    text : str
        Content of the markdown document.
    toc : str
        Table of content, as returned by `build_toc`.

    Returns
    -------
    str
        Content of the document with the table of content in it.

    Example
    -------
    >>> print(insert_toc("# Title\\n\\ntext\\n", "- [Title](#title)"))
    <!-- toc -->
    - [Title](#title)
    <!-- /toc -->
    <BLANKLINE>
    # Title
    <BLANKLINE>
    text
    <BLANKLINE>

    """
    block = f"{BEGIN_MARKER}\n{toc}\n{END_MARKER}\n"
    lines = text.split("\n")
    if BEGIN_MARKER in text:
        begin = next(i for i, line in enumerate(lines) if BEGIN_MARKER in line)
        end = begin
        for number, line in enumerate(lines[begin + 1 :], start=begin + 1):
            if END_MARKER in line:
                end = number
                break
        return "\n".join(lines[:begin] + block.split("\n")[:-1] + lines[end + 1 :])
    start = 0
    if lines and lines[0].strip() == "---":
        for number, line in enumerate(lines[1:], start=1):
            if line.strip() in ("---", "..."):
                start = number + 1
                break
    while start < len(lines) and not lines[start].strip():
        start += 1
    return "\n".join(lines[:start]) + ("\n" if start else "") + block + "\n" + "\n".join(lines[start:])


def render_html(md_path, html_path):
    """Render a markdown file to a standalone HTML file with pandoc

    The `gfm` reader is used so that pandoc generates the same heading
    identifiers as the GitHub style slugs used in the table of content.

    Parameters
    ----------
    md_path : pathlib.Path
        Path to the markdown file to render.
    html_path : pathlib.Path
        Path of the HTML file to write.

    Returns
    -------
    None

    """
    subprocess.run(
        [
            "pandoc",
            "--from=gfm+yaml_metadata_block",
            "--to=html5",
            "--standalone",
            "--metadata=title:" + md_path.stem,
            "--output=" + str(html_path),
            str(md_path),
        ],
        check=True,
    )


def main(argv=None):
    """Parse the command line arguments and write the table of content"""
    parser = argparse.ArgumentParser(
        description=__doc__.split("\n")[0],
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="example: python md_toc.py ../python.Rmd -o /tmp/toc/ --html",
    )
    parser.add_argument("markdown_file", type=Path, help="input markdown file")
    destination = parser.add_mutually_exclusive_group()
    destination.add_argument(
        "-o",
        "--outdir",
        type=Path,
        help="write a copy of the document with the table of content in this "
        "directory, instead of printing the table of content",
    )
    destination.add_argument(
        "-i",
        "--in-place",
        action="store_true",
        help="insert the table of content into the input file itself, just "
        "after the YAML front matter",
    )
    parser.add_argument(
        "--html",
        action="store_true",
        help="also render the copy to HTML with pandoc, to check the links",
    )
    parser.add_argument("--min-level", type=int, default=1, help="default 1")
    parser.add_argument("--max-level", type=int, default=3, help="default 3")
    args = parser.parse_args(argv)

    if args.html and not args.outdir:
        parser.error("--html requires --outdir")
    if not args.markdown_file.is_file():
        parser.error(f"no such file: {args.markdown_file}")

    text = args.markdown_file.read_text(encoding="utf-8")
    headings = find_headings(text.split("\n"), args.min_level, args.max_level)
    if not headings:
        sys.exit(f"no heading between level {args.min_level} and {args.max_level}")
    toc = build_toc(headings)

    if args.in_place:
        args.markdown_file.write_text(insert_toc(text, toc), encoding="utf-8")
        print(f"edited {args.markdown_file}")
        return
    if not args.outdir:
        print(toc)
        return
    args.outdir.mkdir(parents=True, exist_ok=True)
    md_path = args.outdir / args.markdown_file.name
    md_path.write_text(insert_toc(text, toc), encoding="utf-8")
    print(f"wrote {md_path}")
    if args.html:
        html_path = md_path.with_suffix(".html")
        render_html(md_path, html_path)
        print(f"wrote {html_path}")


if __name__ == "__main__":
    main()
