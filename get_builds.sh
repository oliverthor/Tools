#!/bin/bash
#
# Past Authors:		Roland Kunkel
# Current Author:	Oliver Nelson
# Date: 	8-12-14 -- RK
#		10-15-14 -- ON
# Last Update:	01-17-15 -- ON

# Purpose:	
#
#		To pull needed Flame builds and place them in the correct directories

# Updating:
#
#		2014-09-03 # Added OMC for old master set it to 2.1
#                          # Changed MC to point to 2.2 lastest nightly
#               2014-09-15 # Added get pull for flame.zip, this includes the full flash
#               2014-09-16 # pull for flame is breaking everything... removed for now
#               2014-09-19 # updated to pull KK builds down
#			   # correctly pulls flame image down now
#               2014-09-22 # b2g-distro was not being deleted after pull, updated to fix error
#               2014-09-23 # .config from the flame.zip is not being pulled properly, commenting out that code
#                          # changed the naming convention for flame KK builds
#               2014-09-25 # .config is now being pulled properly
#                          # I am now pulling down the sources.xml
#                          # pulling down nightly flame KK builds now
#                          # no longer pulling down regular nightly builds down
#                          # I am now pulling boot.img and replacing the borked one located in the pulled flame-kk.zip
#                          # cleaned up my varibles to reduce total number
#                          # changed file structure so that we can have an assets folder in needed_scripts for solidarity
#                          # now pulls '/mnt/builds/Needed_Scripts/flash_Gg.sh' flash script 
#               2014-09-26 # now pulls latest 2.0 KK builds
#               2014-09-26 # no longer re-naming the b2g-folder, trade off BugGUI no longer supports pulling
                           # from the directory for 1.4 prior
#		2014-10-15 # added support for pulling new 2.1 branch [b2g-34]
#		2014-10-18 # added function to reduce redundant calls
#		2014-10-19 # added framework for looping through builds [WIP]
#		2014-11-25 # reorganizing variables by paths
#		2014-12-19 # added intro to script to help guide functionality
#			     user input flow to perform script without arguments given
#		2014-12-23 # added credentials request for pvt: does not elegantly break with improper login yet
#		2015-01-12 # added support for 3.0 builds
#		2015-01-16 # added framework for a boot image input flag, determining to copy the boot from Assets or not
		

### Variables
# Security 
#USER=''
#PASS=''
USER='onelson@qanalydocs.com'
PASS='xYaUSsyYfyCV98nm'

# Generic
BUILDID=''
GAIA='gaia.zip'
IMAGE='flame-kk.zip'
SOURCES='sources.xml'
BOOT_IMAGE='/mnt/builds/Needed_Scripts/Assets/boot.img'
#LC_BOOT_IMAGE=

#trying to set a boot flag
#BOOT_PATH='/mnt/builds/Needed_Scripts/Assets/boot.img'
#BOOT_CONFIRM= false

FLASH_SCRIPT='/mnt/builds/Needed_Scripts/flash_Gg.sh'

DIR_LOC=$HOME'/Desktop/builds'
DIR_SER='/mnt/builds'
CUR_DIR=$DIR_SER
#BUILD_ID='latest'
#string to parse into for build id: 2014/12/2014-12-09-17-01-21/

# MC_KK 3.0
#MC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk/latest/'
TO_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk/latest/'
TO_KK_B2G='b2g-42.0a1.en-US.android-arm.tar.gz'
#TO_KK_B2G='b2g-40.0a1.en-US.android-arm.tar.gz'
#TO_KK_B2G='b2g-39.0a1.en-US.android-arm.tar.gz'
TO_EN_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk-eng/latest/'
#MC_KK_DIR_SER='/mnt/builds/Flame/Flame_KK/2.2/Central'
#MC_EN_DIR_SER='/mnt/builds/Flame/Flame_KK/2.2/Engineering'
TO_KK='/Flame/Flame_KK/3.0/Central'
TO_EN='/Flame/Flame_KK/3.0/Engineering'


# MC_KK 2.2
#MC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk/latest/'
MC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g37_v2_2-flame-kk/latest'
MC_KK_B2G='b2g-37.0.en-US.android-arm.tar.gz'
MC_EN_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g37_v2_2-flame-kk-eng/latest/'
#MC_KK_DIR_SER='/mnt/builds/Flame/Flame_KK/2.2/Central'
#MC_EN_DIR_SER='/mnt/builds/Flame/Flame_KK/2.2/Engineering'
MC_KK='/Flame/Flame_KK/2.2/b2g37'
MC_EN='/Flame/Flame_KK/2.2/Engineering'


# B2G-34 2.1 as of 10/10 -- 11/25 w/ Engineering
B34_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g34_v2_1-flame-kk/latest/'
B34_KK_B2G='b2g-34.0.en-US.android-arm.tar.gz'
B34_EN_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g34_v2_1-flame-kk-eng/latest/'
B34_TB_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/tinderbox-builds/mozilla-b2g34_v2_1-flame-kk-eng/latest/'
#B34_KK_DIR_SER='/mnt/builds/Flame/Flame_KK/2.1/b2g-34' 
#B34_EN_DIR_SER='/mnt/builds/Flame/Flame_KK/2.1/Engineering'
B34_KK='/Flame/Flame_KK/2.1/b2g-34'
B34_EN='/Flame/Flame_KK/2.1/Engineering'


# LC_KK 2.0
LC_KK_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-b2g32_v2_0-flame-kk/latest/'
LC_KK_B2G='b2g-32.0.en-US.android-arm.tar.gz'
#LC_KK_DIR_SER='/mnt/builds/Flame/Flame_KK/2.0' #'$HOME/Desktop/oliverthor/builds/2.0' 
LC_KK='/Flame/Flame_KK/2.0'

# TO Experiment
#TO_PATH='https://pvtbuilds.mozilla.org/pvt/mozilla.org/b2gotoro/nightly/mozilla-central-flame-kk/"

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
  curl -# --anyauth -L -u $USER:$PASS $1/$2 -o $2
}

# Get tar files 
function get_tar() {
  curl -# --anyauth -L -u $USER:$PASS $1/$2 -o $2
  tar -zxf $2
}

# Get zip files
function get_zip() {
  curl -# --anyauth -L -u $USER:$PASS $1/$2 -o $2
  unzip -q $2
}

# Pull all Build files
function assemble_build() {
 #$1 = $BUILD_PATH
 #$2 = $BUILD_B2G
  echo "Downloading B2G..."
  get_tar $1 $2
  
  echo "Downloading Gaia..."
  get_zip $1 $GAIA
  
  echo "Downloading Image..."
  get_zip $1 $IMAGE
  
  echo "Downloading Sources..."
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

  # replace old boot
  #cp $BOOT_IMAGE $DIRNAME'/b2g-distro/out/target/product/flame'
  
  # add flash script
  cp $FLASH_SCRIPT $DIRNAME
}

### Pull Build Functions
function pull_3_0() {
  # Mozilla Master Central KK
  #cd '/mnt/builds/Flame/Flame_KK/3.0/Central
  cd $CUR_DIR$TO_KK
  pwd
  echo "Starting KK v3.0"
  assemble_build $TO_KK_PATH $TO_KK_B2G

}

function pull_3_0E() {
  # Mozilla Master Central KK
  #cd '/mnt/builds/Flame/Flame_KK/3.0/Central
  cd $CUR_DIR$TO_EN
  pwd
  echo "Starting KK v3.0 [Nightly Engineering]"
  assemble_build $TO_EN_PATH $TO_KK_B2G

}

function pull_2_2() {
    # Mozilla Master Central KK
    #cd '/mnt/builds/Flame/Flame_KK/2.2/Central'
    #cd $MC_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.2'

    #cd $MC_KK_DIR_SER
    cd $CUR_DIR$MC_KK
    pwd
    echo "Starting KK v2.2"
    assemble_build $MC_KK_PATH $MC_KK_B2G
}

function pull_2_2E() {
    # Mozilla Master Central KK
    #cd '/mnt/builds/Flame/Flame_KK/2.2/Central'
    #cd $ENG_CEN_DIR #$HOME'/Desktop/oliverthor/builds/2.2'
    #cd $MC_EN_DIR_SER
    cd $CUR_DIR$MC_EN
    pwd
    echo "Starting 2.2E [Nightly Engineering]"
    assemble_build $MC_EN_PATH $MC_KK_B2G
}

function pull_2_1() {
    # Mozilla b2g-34 KK -- 2.1
    #temp=$HOME'/Desktop/oliverthor/builds/2.1'
    #cd $B2G_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.1' #$B2G_KK_DIR
    cd $CUR_DIR$B34_KK
    pwd
    echo "Starting KK v2.1 -- b2g-34"
    assemble_build $B34_KK_PATH $B34_KK_B2G
}

function pull_2_1E() {
    # Mozilla b2g-34 KK -- 2.1
    #temp=$HOME'/Desktop/oliverthor/builds/2.1'
    #cd $B2G_KK_DIR #$HOME'/Desktop/oliverthor/builds/2.1' #$B2G_KK_DIR
    cd $CUR_DIR$B34_EN
    pwd
    echo "Starting KK v2.1 -- b2g-34 [Nightly Engineering]"
    assemble_build $B34_EN_PATH $B34_KK_B2G
}

function pull_2_1TB() {

    cd $CUR_DIR$B34_EN
    pwd
    echo "Starting KK v2.1 -- b2g-34 [Tinderbox Engineering]"
    assemble_build $B34_TB_PATH $B34_KK_B2G
}

function pull_2_0() {
    # Mozilla b2g-34 KK -- 2.1
    #cd '/mnt/builds/Flame/Flame_KK/2.0'
    #cd $HOME'/Desktop/oliverthor/builds/2.0'
    #cd $LC_KK_DIR_SER
    cd $CUR_DIR$LC_KK
    pwd
    echo "Starting KK v2.0"
    assemble_build $LC_KK_PATH $LC_KK_B2G
}

function pull_builds_args()
{
    case $1 in	
	'2.0') pull_2_0;;
	'2.1') pull_2_1;;
	'2.1E') pull_2_1E;;
	'2.1TB') pull_2_1TB;;
	'2.2') pull_2_2;;
	'2.2E') pull_2_2E;;
	'3.0') pull_3_0;;
	'3.0E') pull_3_0E;;
	'all')
	echo "all -- pulling all builds: 3.0, 3.0E, 2.2, 2.2E, 2.1, 2.1E, 2.0"
	    pull_3_0
	    pull_3_0E
	    pull_2_2
	    pull_2_2E
	    pull_2_1
	    pull_2_1E
	    pull_2_0
	    ;;
	'3.0X')
	    echo "3.0X -- pulling all 3.0: user + eng"
	    pull_3_0
	    pull_3_0E
	    ;;
	'2.2X')
	    echo "2.2X -- pulling all 2.2: user + eng"
	    pull_2_2
	    pull_2_2E
	    ;;
	'smoke')
	echo "smoke -- pulling builds for smoketeam: latest master [user + eng], 2.2, 2.1, 2.0"
	    pull_3_0
	    pull_3_0E
	    pull_2_2
	    pull_2_1
	    pull_2_0
	    ;;
	'user')
	echo "user -- pulling builds for test team: 2.2, 2.1, 2.0"
	    pull_3_0
	    pull_2_2
	    pull_2_1
	    pull_2_0
	    ;;
	'eng'*)
	echo "engineering -- pulling eng. builds: 2.2E, 2.1E"
	    pull_3_0E
	    pull_2_2E
	    pull_2_1E
	    ;;
	*) echo "No Argument: provide '3.0','2.0', '2.1','2.2', or '2.2E', '2.1E or '2.1TB' to pull a particular build.";;
    esac
}

function displayIntro()
{
  echo "GET BUILDS"
  echo "**********"
  
  if [ -z "$USER" ]; then
    echo "Need pvt login credentials:"
    echo "---------------------------"
    read -p 	"Username: " USER
    read -s -p 	"Password: " PASS
  else
    echo "Using credentials of $USER"
  fi
  echo "****************************************************************"
  echo "#.# -- pull down latest of that respective build (2.2, 2.1, 2.0, 2.2E, 2.1E, 2.1TB)"
  echo "smoke -- latest 3.0, 2.2, 2.1, 2.2E and 2.1E"
  echo "all -- latest 3.0, 2.2, 2.1, 2.0, 2.2E and 2.1E"
  echo "user -- latest 3.0, 2.2, 2.1 and 2.0"
  echo "eng -- latest 3.0, 2.2 and 2.1 Engineering [from nightly]"
  echo "----------------------------------------------------------------"
  echo "Flags:"
  echo "-s : download to server [default]"
  echo "-l : download to local machine [/home/flash/desktop/builds]"
  echo "-b : copy the boot image to build folder [incomplete]"
  echo "----------------------------------------------------------------"

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
#Get_Opts -- function wasn't working?

CUR_DIR=$DIR_SER
while getopts :lsb opt; do
  case $opt in
  l) echo -e "L: Download Paths Set to Local Machine -- $DIR_LOC" #set local download paths
    
    # create local directories
    mkdir -p $DIR_LOC$MC_KK
    mkdir -p $DIR_LOC$MC_EN
    mkdir -p $DIR_LOC$B34_KK
    mkdir -p $DIR_LOC$B34_EN
    mkdir -p $DIR_LOC$LC_KK
    CUR_DIR=$DIR_LOC
  
    ;;
  s) echo "S: Download Paths Set to Server -- $DIR_SER" #set server download paths
    CUR_DIR=$DIR_SER
    ;;
  b) echo "B: Copy Boot Image" #copy the boot image, otherwise will not
     #BOOT_IMAGE= $BOOT_PATH
     #echo "Boot Image set to $BOOT_CONFIRM, copying boot image to build"
     ;;
  *)
  ;;
  esac
done

# handle args after opts
shift $(($OPTIND - 1))
first_arg=$1

displayIntro
if [ -z "$first_arg" ]; then
  echo "Select builds to download: "
  read first_arg
  
  if [[ "$CUR_DIR" != "$DIR_LOC" ]]; then
    echo "Download Path: [server/local]"
    DL_DIR="server"
    read DL_DIR
    case $DL_DIR in
      'server')
	CUR_DIR=$DIR_SER
	;;
      'local')
	CUR_DIR=$DIR_LOC
	;;
    esac
  fi
fi
#second_arg=$2
#printf "$CURDIR set for download.\nBuilds:\n- 2.2 [User]\n- 2.2E [Engineering]\n2.1 [User]\n2.1E [Engineering]\n- 2.0 [User]"

printf "DOWNLOAD PATH: $CUR_DIR\n"
printf "BUILDS TO DOWNLOAD: $first_arg\n"
echo "**********************"
echo "Confirm above to download: (y/n)"

#RUN_BUILDS="y"
read RUN_BUILDS

if [[ "$RUN_BUILDS" = "y" ]]; then

  if [[ "$CUR_DIR" = "$DIR_LOC" ]]; then
    #echo "cur dir is equal to local"
    if [ ! -d '/home/flash/Desktop/builds/' ]; then
      mkdir -p $DIR_LOC$TO_KK
      mkdir -p $DIR_LOC$MC_KK
      mkdir -p $DIR_LOC$MC_EN
      mkdir -p $DIR_LOC$B34_KK
      mkdir -p $DIR_LOC$B34_EN
      mkdir -p $DIR_LOC$LC_KK
    fi
  fi

  pull_builds_args $first_arg
fi

# End Timer
currTime=$(date +"%s")
diff=$(($currTime-$runTime))
TIME_ELAPSED="$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
