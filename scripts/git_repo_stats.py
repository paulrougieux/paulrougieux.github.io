"""Generate statistics from a git repository

Return a list of each commit with day, time and the number of line added or
removed in the git repository. The output data frame should be like this:

Usage:

    cd ~/rp/paulrougieux.github.io/scripts && ipython -i git_repo_stats.py

    >>> get_git_log_dataframe("/home/paul/repos/eu_cbm/eu_cbm_hat")

Alternative considerations

- I considered using gitpython, but the maintain says it's in maintenance stage
  and he is now using rust to interact with python.

- This reddit thread says using subprocess might be just as fine in the end if
  you don't need to much interaction
  https://www.reddit.com/r/Python/comments/6k8h43/best_git_module_for_python/?rdt=63908

"""


import subprocess
import pandas as pd
import re
from datetime import datetime

def get_git_log_dataframe(path):
    # Git log format:
    # %H: commit hash
    # %ad: author date (format respects --date=format)
    # %an: author name
    # %s: subject (commit message first line)
    git_log_cmd = [
        'git', 'log', 
        '--pretty=format:%H|%ad|%an|%s',
        '--date=format:%Y%m%d %H:%M:%S',
        '--numstat'
    ]
    
    try:
        # Run git log command and capture output
        git_log_output = subprocess.check_output(git_log_cmd, cwd=path).decode('utf-8', errors='replace')
        
        # Split the output into commits
        commits_data = []
        current_commit = None
        
        for line in git_log_output.split('\n'):
            if '|' in line:  # This is a commit header line
                # Save previous commit if it exists
                if current_commit:
                    commits_data.append(current_commit)
                
                # Parse the commit header
                hash_val, date_str, author, subject = line.split('|', 3)
                date_parts = date_str.split()
                day = date_parts[0]
                time = datetime.strptime(date_parts[1], "%H:%M:%S").strftime("%I:%M:%S %p")
                
                current_commit = {
                    'day': day,
                    'time': time,
                    'commit_hash': hash_val,
                    'lines_added': 0,
                    'lines_removed': 0,
                    'Name': author,
                    'description': subject
                }
            elif line.strip() and current_commit is not None:
                # This is a stats line (lines added/removed)
                parts = line.strip().split('\t')
                if len(parts) == 3 and parts[0] != '-' and parts[1] != '-':
                    # Add up the lines added/removed
                    current_commit['lines_added'] += int(parts[0]) if parts[0].isdigit() else 0
                    current_commit['lines_removed'] += int(parts[1]) if parts[1].isdigit() else 0
        
        # Add the last commit
        if current_commit:
            commits_data.append(current_commit)
        
        # Create DataFrame
        df = pd.DataFrame(commits_data)
        
        # Reorder columns to match desired output
        column_order = ['day', 'time', 'commit_hash', 'lines_added', 'lines_removed', 
                        'Name', 'commit_hash', 'description']
        
        # Handle duplicated column names
        df = df[list(dict.fromkeys(column_order))]
        
        return df
    
    except subprocess.CalledProcessError as e:
        print(f"Error executing git command: {e}")
        return pd.DataFrame()
    except Exception as e:
        print(f"An error occurred: {e}")
        return pd.DataFrame()

if __name__ == "__main__":
    # Make sure to run this script from within a git repository
    this_path = "/home/paul/rp/paulrougieux.github.io"
    df = get_git_log_dataframe(this_path)
    
    if not df.empty:
        print(df.to_string(index=False))
        
        # Optionally save to CSV
        # df.to_csv('git_commit_history.csv', index=False)
    else:
        print("No data found or error occurred.")
