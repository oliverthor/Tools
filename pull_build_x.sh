#!/bin/bash
#
# Author:	Oliver Nelson
# Date:		10-27-2014

# Purpose:	
#
#		Pull a single build down from the repository based on input [and maybe selection]

# Updating:
#
#		2014-10-27 # narrowed function calls to single pull_single_build; discerns given argument and pulls respective build
#		2014-11-12 # downloading locally atm, add into flag and enable pulling to network naturally
#				Local Dir: /home/flash/Desktop/builds/[2.0/2.1/2.2/2.2E]
		

### Variables
# X build
BUILDX=$1

# Security 
USER='onelson@qanalydocs.com'
PASS='xYaUSsyYfyCV98nm'

# Generic
BUILDID=''
GAIA='gaia.zip'
IMAGE='flame-kk.zip'
SOURCES='sources.xml'
#BOOT_IMAGE='/mnt/builds/Needed_Scripts/Assets/boot.img'
FLASH_SCRIPT='/mnt/builds/Needed_Scripts/flash_Gg.sh'

# MC_KK 2.2
MC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk/latest/'
MC_KK_B2G='b2g-37.0a1.en-US.android-arm.tar.gz'
#MC_KK_DIR='/mnt/builds/Flame/Flame_KK/2.2/Central'
#MC_KK_DIR= "$HOME/Desktop/oliverthor/builds/2.2"3
MC_KK_DIR='home/flash/Desktop/builds/2.2'

ENG_CEN_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk-eng/latest/'
ENG_CEN_DIR='/mnt/builds/Flame/Flame_KK/2.2/Engineering'

# OMC_KK 2.1
#OMC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-aurora-flame-kk/latest/'
#OMC_KK_B2G='b2g-34.0a2.en-US.android-arm.tar.gz'
#OMC_KK_DIR='/mnt/builds/Flame/Flame_KK/2.1' #'$HOME/Desktop/oliverthor/builds/2.1/aurora'


# B2G-34 2.1 as of 10/10
B2G34_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g34_v2_1-flame-kk/latest/'
B2G34_KK_B2G='b2g-34.0.en-US.android-arm.tar.gz'
B2G34_KK_DIR='/mnt/builds/Flame/Flame_KK/2.1/b2g-34' 
#B2G34_KK_DIR= $HOME'/Desktop/oliverthor/builds/2.1/'
#MC_KK_LOC='home/flash/Desktop/builds/2.1'
ENG_B34_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g34_v2_1-flame-kk-eng/latest/'
ENG_B34_DIR='/mnt/builds/Flame/Flame_KK/2.1/Engineering'

# LC_KK 2.0
LC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g32_v2_0-flame-kk/latest/'
LC_KK_B2G='b2g-32.0.en-US.android-arm.tar.gz'
#LC_KK_DIR='/mnt/builds/Flame/Flame_KK/2.0' #'$HOME/Desktop/oliverthor/builds/2.0' 


# Build Path Container
#BUILD_PATHS[0]=	$MC_KK_PATH
#BUILD_B2GS[0]= 	$MC_KK_B2G
#BUILD_DIRS[0]=	$MC_KK_DIR	

#BUILD_PATHS[1]=	$OMC_KK_PATH
#BUILD_B2GS[1]=	$OMC_KK_B2G
#BUILD_DIRS[1]=	$OMC_KK_DIR

#BUILD_PATHS[2]=	$B2G34_KK_PATH
#BUILD_B2GS[2]=	$B2G34_KK_B2G
#BUILD_DIRS[2]=	$B2G34_KK_DIR

#BUILD_PATHS[3]=	$LC_KK_PATH
#BUILD_B2GS[3]=	$LC_KK_PATH
#BUILD_DIRS[3]=	$LC_KK_DIR

### Functions
# Get file
function get_file() {
  curl --anyauth -L -u $USER:$PASS $1/$2 -o $2
}

# Get tar files 
function get_tar() {
  curl --anyauth -L -u $USER:$PASS $1/$2 -o $2
  tar -zxf $2
}

# Get zip files
function get_zip() {
  curl --anyauth -L -u $USER:$PASS $1/$2 -o $2
  unzip -q $2
}

# Pull all Build files
function assemble_build() {
 #$1 = $BUILD_KK_PATH
 #$2 = $BUILD_KK_B2G
  get_tar $1 $2
  get_zip $1 $GAIA
  get_zip $1 $IMAGE
  get_file $1 $SOURCES
  create_name
  clean_kk $2 $GAIA $IMAGE $SOURCES 
}

# Create proper name
function create_name() {
  for a in BuildID; do
    BUILDID=$(grep "^ *$a" "b2g/application.ini" | sed "s,.*=,,g")
  done
}

function clean_kk() {
  echo "Cleaning..."
  DIRNAME=$(echo $BUILDID)
  mkdir $DIRNAME
  mv 'b2g' $DIRNAME
  mv 'gaia' $DIRNAME
  cp -r 'b2g-distro' $DIRNAME
  #mv $DIRNAME'/b2g-distro' $DIRNAME'/fullflash' # gg script does not support renaming the b2g-distro
  mv $4 $DIRNAME
  rm $1
  rm $2
  rm $3
  rm -rf b2g-distro/

  # replace old boot -- outdated as of 11/24
  #cp $BOOT_IMAGE $DIRNAME'/b2g-distro/out/target/product/flame'
  # add flash script
  cp $FLASH_SCRIPT $DIRNAME
}

function pull_2_2() {
    # Mozilla Master Central KK
    #cd '/mnt/builds/Flame/Flame_KK/2.2/Central'
    #cd $MC_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.2'

    cd $MC_KK_DIR
    pwd
    echo "Starting KK v2.2"
    assemble_build $MC_KK_PATH $MC_KK_B2G
}

function pull_2_2E() {
    # Mozilla Master Central KK
    #cd '/mnt/builds/Flame/Flame_KK/2.2/Central'
    #cd $ENG_CEN_DIR #$HOME'/Desktop/oliverthor/builds/2.2'
    cd $ENG_CEN_DIR
    pwd
    echo "Starting 2.2E [Nightly Engineering]"
    #assemble_build $ENG_CEN_PATH $MC_KK_B2G
}

function pull_2_1() {
    # Mozilla b2g-34 KK -- 2.1
    #temp=$HOME'/Desktop/oliverthor/builds/2.1'
    #cd $B2G_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.1' #$B2G_KK_DIR
    cd $B2G34_KK_DIR
    #cd '2.1'
    pwd
    echo "Starting KK v2.1 -- b2g-34"
    #assemble_build $B2G34_KK_PATH $B2G34_KK_B2G
}

function pull_2_1E() {
    # Mozilla b2g-34 KK -- 2.1
    #temp=$HOME'/Desktop/oliverthor/builds/2.1'
    #cd $B2G_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.1' #$B2G_KK_DIR
    cd $ENG_B34_DIR
    pwd
    echo "Starting KK v2.1 -- b2g-34 [Nightly Engineering]"
    #assemble_build $ENG_B34_PATH $B2G34_KK_B2G
}

function pull_2_0() {
    # Mozilla b2g-34 KK -- 2.1
    #cd '/mnt/builds/Flame/Flame_KK/2.0'
    #cd $HOME'/Desktop/oliverthor/builds/2.0'
    cd '2.0'
    pwd
    echo "Starting KK v2.0"
    #assemble_build $LC_KK_PATH $LC_KK_B2G
}

function pull_single_build()
{
    case $1 in	
	*'2.0'*) pull_2_0;;
	*'2.1') pull_2_1;;
	*'2.1E') pull_2_1E;;
	*'2.2') pull_2_2;;
	*'2.2E') pull_2_2E;;
	      *) echo "No Argument: provide '2.0', '2.1','2.2', or '2.2E' to pull a particular build.";;
    esac
}

### Main

# Timer
runTime=$(date +"%s")

# Assemble Build Loop
# get the length of the arrays
#length=${#BUILD_PATHS[@]}
# do the loop
#for ((i=0;i<1;i++)); do
	#echo ${BUILD_DIRS[i]}
	#cd ${BUILD_DIRS[i]}
	#assemble_build ${BUILD_PATH[i]} ${BUILD_B2GS[i]}
#done
cd '/home/flash/Desktop'
#cd 'Desktop'
pwd


if [ ! -d 'builds' ]; then
  mkdir 'builds' &&	
  mkdir 'builds/2.0' &&
  mkdir 'builds/2.1' &&
  mkdir 'builds/2.2' &&
  mkdir 'builds/2.2E'
fi

#cd 'builds'
pull_single_build $1

# End Timer
currTime=$(date +"%s")
diff=$(($currTime-$runTime))
TIME_ELAPSED="$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."

