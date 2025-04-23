"""Generate statistics from a git repository

Return a list of each commit with day, time and the number of line added or
removed in the git repository. The output data frame should be like this:

Usage:

    cd ~/rp/paulrougieux.github.io/scripts && ipython -i git_repo_stats.py /home/paul/repos/eu_cbm/eu_cbm_hat

Once started in python, you can call the function

    >>> df_eu_cbm_hat = get_git_log_dataframe(repository_path="/home/paul/repos/eu_cbm/eu_cbm_hat")
    >>> df_eu_cbm_data = get_git_log_dataframe(repository_path="/home/paul/repos/eu_cbm/eu_cbm_data")

Alternative considerations

- I considered using gitpython, but the maintain says it's in maintenance stage
  and he is now using rust to interact with python.

- This reddit thread says using subprocess might be just as fine in the end if
  you don't need to much interaction
  https://www.reddit.com/r/Python/comments/6k8h43/best_git_module_for_python/?rdt=63908

"""
import sys
import pandas as pd
import pygit2
from datetime import datetime

def get_git_log_dataframe(repository_path='.'):
    """
    Extract commit information from a git repository using pygit2.

    Parameters:
    repository_path (str): Path to the git repository

    Returns:
    pandas.DataFrame: DataFrame containing commit information
    """
    try:
        # Open the repository
        repo = pygit2.Repository(repository_path)

        commits_data = []

        # Walk through commit history
        for commit in repo.walk(repo.head.target, pygit2.GIT_SORT_TIME):
            # Get commit details
            commit_hash = str(commit.id)[:7]  # Short hash
            author = commit.author
            name = author.name
            timestamp = author.time
            message = commit.message.strip().split('\n')[0]  # First line of commit message

            # Convert timestamp to day and time
            dt = datetime.fromtimestamp(timestamp)
            day = dt.strftime('%Y%m%d')
            time = dt.strftime('%I:%M:%S %p')

            # Calculate lines added/removed if there's a parent
            lines_added = 0
            lines_removed = 0

            if len(commit.parents) > 0:
                parent = commit.parents[0]
                diff = repo.diff(parent, commit)

                for patch in diff:
                    # Count line changes in each file
                    lines_added += patch.line_stats[1]  # Added lines
                    lines_removed += patch.line_stats[2]  # Removed lines

            # Create a dict for this commit
            commit_data = {
                'day': day,
                'time': time,
                'commit_hash': commit_hash,
                'lines_added': lines_added,
                'lines_removed': lines_removed,
                'Name': name,
                'description': message
            }

            commits_data.append(commit_data)

        # Create DataFrame
        df = pd.DataFrame(commits_data)

        # Reorder columns to match desired output
        column_order = ['day', 'time', 'commit_hash', 'lines_added', 'lines_removed',
                        'Name', 'commit_hash', 'description']

        # Handle duplicated column names by selecting unique columns
        # (Note: commit_hash appears twice in your example)
        df = df[list(dict.fromkeys(column_order))]

        return df

    except Exception as e:
        print(f"An error occurred: {e}")
        return pd.DataFrame()

# This code will run when imported or executed directly
if __name__ == "__main__":
    # Default to current directory if no argument provided
    repo_path = sys.argv[1] if len(sys.argv) > 1 else '.'

    print(f"Analyzing git repository at: {repo_path}")
    df = get_git_log_dataframe(repo_path)

    if not df.empty:
        print(f"Found {len(df)} commits.")
        print("\nSample of commits:")
        print(df.head().to_string(index=False))
    else:
        print("No data found or error occurred.")

# When run with ipython -i, these variables will be available in the interactive session
print("\nTo access the full dataframe, use the 'df' variable")
