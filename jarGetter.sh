#!/bin/bash
  ###### ######## ####### #######  ###  #######
###           ##       ##      ## ###
###      #######  ######  ###  ## ###  #######
###      ###  ##  ##  ##  ###  ## ###  ##
 ######  ###  ##  ##   ## ######  ###  ##

# arguments
VERSION=${1}

URL=https://papermc.io/api/v2/projects/paper

if [ ${VERSION} = latest ]
then
  # Get the latest MC version
  VERSION=$(wget -qO - $URL | jq -r '.versions[-1]') # "-r" is needed because the output has quotes otherwise
fi
URL=${URL}/versions/${VERSION}
PAPER_BUILD=$(wget -qO - $URL | jq '.builds[-1]')
JAR_NAME="paper-${VERSION}-${PAPER_BUILD}.jar"
URL=${URL}/builds/${PAPER_BUILD}/downloads/${JAR_NAME}

wget ${URL} -O ./${JAR_NAME}
