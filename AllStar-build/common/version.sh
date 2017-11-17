#!/bin/bash
# version.sh - Display software version, and check
# for available updates
#    Copyright (C) 2017  Jeremy Lincicome (W0JRL)
#    https://jlappliedtechnologies.com  admin@jlappliedtechnologies.com

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Does not perform system update
# Will run automaticly at root log in
# Script Start
cd /usr/src/utils
echo "Your software version is: $( git describe --always )."
echo "Your last update was on: $( cat /root/.lastupdate )."
echo "Checking for available updates..."
git fetch &>/dev/null
echo "Done"
echo "Your repository branch is set to: $( git status | grep "branch" | sed 's/On branch//' | sed 's/git pull/system-update/' | sed 's/to update your local branch/to UPDATE YOUR NODE/' | sed 's/up-to-date/UP-TO-DATE/' )"
echo "You can review this information at any time by typing
'version' at a root prompt."
exit 0