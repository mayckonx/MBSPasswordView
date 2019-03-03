
# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress", sticky: true) if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR", sticky: true) if git.lines_of_code > 500

## Let's check if there are any changes in the project folder
has_app_changes = !git.modified_files.grep(/ProjectName/).empty?
## Then, we should check if tests are updated
has_test_changes = !git.modified_files.grep(/ProjectNameTests/).empty?
## Finally, let's combine them and put extra condition 
## for changed number of lines of code
if has_app_changes && !has_test_changes && git.lines_of_code > 20
  fail("Tests were not updated", sticky: false)
end

# SwiftLint
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true
