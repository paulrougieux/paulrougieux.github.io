"""Generate statistics from a git repository

Return a list of each commit with day, time and the number of line added or
removed in the git repository. The output data frame should be like this:

Usage:

    cd ~/rp/paulrougieux.github.io/scripts && ipython -i git_repo_stats.py /home/paul/repos/eu_cbm/eu_cbm_hat

Once started in python, you can call the function

    >>> df_eu_cbm_hat = get_git_log_dataframe(repository_path="/home/paul/repos/eu_cbm/eu_cbm_hat")
    >>> df_eu_cbm_data = get_git_log_dataframe(repository_path="/home/paul/repos/eu_cbm/eu_cbm_data")

    >>> plot_daily_code_changes(df_eu_cbm_hat, log_scale=True)

Alternative considerations

- I considered using gitpython, but the maintain says it's in maintenance stage
  and he is now using rust to interact with python.

- This reddit thread says using subprocess might be just as fine in the end if
  you don't need to much interaction
  https://www.reddit.com/r/Python/comments/6k8h43/best_git_module_for_python/?rdt=63908

"""

from datetime import datetime
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import pandas as pd
import pygit2
import sys

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

def plot_daily_code_changes(df, figsize=(12, 6), date_format='%Y-%m',
                           date_interval=3, title='Code Changes Over Time',
                           log_scale=False):
    """
    Create a scatter plot showing daily code changes from git commit data.

    Parameters:
    -----------
    df : pandas.DataFrame
        DataFrame containing git commit data with 'day', 'lines_added', and 'lines_removed' columns
    figsize : tuple, optional
        Figure size as (width, height) in inches
    date_format : str, optional
        Format string for date labels on x-axis
    date_interval : int, optional
        Interval between date ticks in months
    title : str, optional
        Plot title
    log_scale : bool, optional
        If True, use logarithmic scale for y-axis

    Returns:
    --------
    matplotlib.figure.Figure
        The figure object containing the plot
    """
    import matplotlib.pyplot as plt
    import pandas as pd
    import numpy as np
    from matplotlib.dates import DateFormatter
    import matplotlib.dates as mdates

    # Group by day and sum lines added/removed
    daily_changes = df.groupby('day').agg({
        'lines_added': 'sum',
        'lines_removed': 'sum'
    }).reset_index()

    # Convert day column to datetime for better x-axis formatting
    daily_changes['date'] = pd.to_datetime(daily_changes['day'], format='%Y%m%d')

    # Create the scatter plot
    fig, ax = plt.subplots(figsize=figsize)

    # Need to handle zeros for log scale
    if log_scale:
        # Filter out zeros for log scale
        log_min = 1  # Minimum value for log scale

        # Plot non-zero additions
        non_zero_added = daily_changes[daily_changes['lines_added'] >= log_min]
        ax.scatter(non_zero_added['date'], non_zero_added['lines_added'],
                   color='green', alpha=0.7, label='Lines Added')

        # Plot non-zero removals with negative sign
        non_zero_removed = daily_changes[daily_changes['lines_removed'] >= log_min]
        ax.scatter(non_zero_removed['date'], -non_zero_removed['lines_removed'],
                   color='red', alpha=0.7, label='Lines Removed')

        # Set log scale for y-axis
        ax.set_yscale('symlog')  # Symmetric log scale to handle negative values

        # Add annotation about log scale
        ax.text(0.02, 0.98, 'Note: Using logarithmic scale',
                transform=ax.transAxes, fontsize=9,
                verticalalignment='top', alpha=0.7)
    else:
        # Regular scale - plot all points
        ax.scatter(daily_changes['date'], daily_changes['lines_added'],
                   color='green', alpha=0.7, label='Lines Added')
        ax.scatter(daily_changes['date'], -daily_changes['lines_removed'],
                   color='red', alpha=0.7, label='Lines Removed')

    # Add a horizontal line at y=0
    ax.axhline(y=0, color='black', linestyle='-', alpha=0.3)

    # Format the x-axis to show dates nicely
    ax.xaxis.set_major_formatter(mdates.DateFormatter(date_format))
    ax.xaxis.set_major_locator(mdates.MonthLocator(interval=date_interval))
    fig.autofmt_xdate()  # Rotate date labels

    # Add labels and title
    ax.set_xlabel('Date')
    y_label = 'Number of Lines (Added/Removed)'
    if log_scale:
        y_label += ' (log scale)'
    ax.set_ylabel(y_label)
    ax.set_title(title)
    ax.legend()
    ax.grid(True, alpha=0.3)

    # Adjust layout
    plt.tight_layout()

    return fig


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
