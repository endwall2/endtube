#!/bin/sh
#################################################################################################################################################
# NAME: endtube.sh
# TYPE: BOURNE SHELL SCRIPT
# DESCRIPTION: Downlods youtube video files from an input video url list
#              and an input proxy url list, by randomizing lists and  
#              anonymously using youtube-dl, torsocks, and the proxy
#
# AUTHOR:  ENDWALL DEVELOPEMENT TEAM
# CREATION DATE:   APRIL 9 2016
# VERSION: 0.10
# REVISION DATE: APRIL 25 2015
# 
# CHANGE LOG:  - Added a bunch of user-agents
#              - Fixed some typos
#              - updated EULA
#              - Fixed randomization of proxies 
#              - Fixed instructions
#
########################################################################################################################################
# DEPENDENCIES: torsocks,youtube-dl,od,head,urandom,sleep
########################################################################################################################################
# INSTRUCTIONS: Make a bin directory in ~/ add it to the path. Copy this file there and make executable.
#               Make a videos directory in Downloads.  Get some download links, and some proxies place in separte text files.
#               Start the TOR daemon. Execute the script in the ~/Download/videos/ directory.    
#   
#  Do the following at a command prompt
#
#  $  mkdir ~/bin
#  $  chmod u+wrx endtube.sh
#  $  cp endtube.sh ~/bin
#  $  export PATH=$PATH:~/bin
#  $  cd Downloads
#  $  mkdir videos
#  $  cd videos
#  $  emacs/nano/leafpad etc  ytlinks.txt  
#
#     Populate list of youtube links into the file ytlinks.txt by right click and paste into the file in a column
#     save ytlinks.txt and exit editor.
# 
#  START TOR DAEMON:
#     SYSTEMD:
#  $ sudo systemctl start tor
#  $ sudo systemctl status tor
#     OPENRC:
#  $ sudo rc-update add tor default
#  $ sudo rc-service start tor
#  $ sudo rc-status
#      
#     Run EndTube 
#  $  endtube ytlinks.txt
#  
#  Using with Proxies:
#  $ emacs/nano/leafpad etc proxies.txt    
#     
#     You will require at least 4 fresh https proxies for operation, get as many as possible
#     Populate the list of proxies from a fresh proxy source, save the list and test the proxies using
#     proxies must be in the file in format protocol://ipv4address:port 
#     eg. https://5.3.55.125:8080
#
#  $  torsocks curl --proxy protocol://ipv4address:port www.google.com
#
#     Run EndTube
#  $  endtube ytinks.txt proxies.txt
#
############################################################################################################################################################################
#                                       ACKNOWLEDGEMENTS
############################################################################################################################################################################
#  The Endwall development team would like to acknowledge the work and efforts of Odilitime, who graciously hosted and promoted this firewall project.
#  Without his efforts and his wonderful website www.endchan.xyz , endwall.sh, endsets.sh, and endtube.sh would not exist in the public domain at all in any form. 
#  Many thanks to Odilitime for inspiring this work and for hosting and promoting it. 
#  
#  Endwall,Endsets,Endlists, and Endtools are named in honor of Endchan.
#
#  Thank you also to early beta testers including a@a, and to other contributors 
#  as well as to the detractors who helped to critique this work and to ultimately improve it.  
#  
#  We also acknowledge paste.debian.net and gitweb for their hosting services, 
#  without which distribution would be limited / impossible, so thank you.
#
#  https://www.endchan.xyz, http://paste.debian.net, http://gitweb2zl5eh7tp3.onion  
#
#  We salute you! 
#  
#  In the end, may it all end well.
#
#  Endwall Development Team
#
##############################################################################################################################################################################
#                                        LICENSE AGREEMENT  
##############################################################################################################################################################################
#  BEGINNING OF LICENSE AGREMENT
#  TITLE:  THE ENDWALL END USER LICENSE AGREEMENT (EULA) 
#  VERSION: 1.05 
#  VERSION DATE: April 19, 2016
#   
#  WHAT CONSTITUES "USE"? WHAT IS A "USER"?
#  0) a) Use of this program means the ability to study, posses, run, copy, modify, publish, distribute and sell the code as included in all lines of this file,
#        in text format or as a binary file consituting this particular program or its compiled binary machine code form, as well as the the performance 
#        of these aforementioned actions and activities. 
#  0) b) A user of this program is any individual who has been granted use as defined in section 0) a) of the LICENSE AGREEMENT, and is granted to those individuals listed in section 1.
#  WHO MAY USE THIS PROGRAM ?
#  1) a) This program may be used by any living human being, any person, any corporation, any company, and by any sentient individual with the willingness and ability to do so.
#  1) b) This program may be used by any citizen or resident of any country, and by any human being without citizenship or residency.
#  1) c) This program may be used by any civilian, military officer, government agent, private citizen, public official, soveriegn, monarch, head of state,
#        dignitary, ambassdor, noble, commoner, clergy, layity, and generally all classes and ranks of people, persons, and human beings mentioned and those not mentioned.
#  1) d) This program may be used by any human being of any gender, including men, women, and any other gender not mentioned.       
#  1) e) This program may be used by anyone of any afiliation, political viewpoint, political affiliation, religious belief, religious affiliation, and by those of non-belief or non affiliation.
#  1) f) This program may be used by any person of any race, ethnicity, identity, origin, genetic makeup, physical apperance, mental ability, and by those of any other physical 
#        or non physical characteristics of differentiation.
#  1) g) This program may be used by any human being of any sexual orientation, including heterosexual, homosexual, bisexual, asexual, or any other sexual orientation not mentioned.
#  1) h) This program may be used by anyone. 
#  WHERE MAY A USER USE THIS PROGRAM ?
#  2) a) This program may be used in any country, in any geographic location of the planet Earth, in any marine or maritime environment, at sea, subsea, in a submarine, underground,
#        in the air, in an airplane, derigible, blimp, or balloon, and at any distance from the surface of the planet Earth, including in orbit about the Earth or the Moon,
#        on a satellite orbiting about the Earth or about any planet, on any space transport vehicle, and anywhere in the solar system including the Moon, Mars, and all other solar system planets not listed.  
#  2) b) This program may be used in any residential, commercial, business, and governmental property or location and in all public and private spaces. 
#  2) c) This program may be used anywhere.
#  IN WHAT CONTEXT OR CIRCUMSTANCES MAY A USER USE THIS PROGRAM?
#  3)  This program may be used by any person, human being or sentient individual for any purpose and in any context and in any setting including for personal use, academic use,
#      business use, commercial use, government use, non-governmental organization use, non-profit organization use, military use, civilian use, and generally any other use 
#      not specifically mentioned.
#  WHAT MAY A "USER" DO WITH THIS PROGRAM ?
#  4) Any user of this program is granted the freedom to study the code.
#  5) a) Any user of this program is granted the freedom to distribute, publish, share the code with any neighbor of their choice electronically or by any other method of transmission. 
#  5) b) The LICENCSE AGREEMENT, ACKNOWLEDGEMENTS, Header and Instructions must remain attached to the code in their entirety when re-distributed.
#  5) c) Any user of this program is granted the freedom to sell this software as distributed or to bundle it with other software or saleable goods.
#  6) a) Any user of this program is granted the freedom to modify and improve the code.
#  6) b) When modified or improved, any user of this program is granted the freedom of re-distribution of their modified code if and only if the user attatchs the LICENSE AGREEMENT
#        in its entirety to their modified code before re-distribution.
#  6) c) Any user of this software is granted the freedom to sell their modified copy of this software or to bundle their modified copy with other software or saleable goods.
#  7) a) Any user of this program is granted the freedom to run this code on any computer of their choice.
#  7) b) Any user of this program is granted the freedom to run as many simultaneous instances of this code, on as many computers as they are able to and desire, and for as long as they desire and are
#        able to do so with any degree of simultaneity in use. 
#  WHAT MUST A "USER" NOT DO WITH THIS PROGRAM ?
#  8) Any user of this program is not granted the freedom to procur a patent for the methods presented in this software, and agrees not to do so.
#  9) Any user of this program is not granted the freedom to arbitrarily procur a copyright on this software as presented, and agrees not to do so.
#  10) Any user of this program is not granted the freedom to obtain or retain intelectual property rights on this software as presented and agrees not to do so.
#  11) a) Any user of this program may use this software as part of a patented process, as a substitutable input into the process; however the user agrees not to attempt to patent this software as part of their patented process. 
#      b) This software is a tool, like a hammer, and may be used in a process which applies for and gains a patent, as a substitutable input into the process;
#         however the software tool itself may not be included in the patent or covered in the patent as a novel invention, and the user agrees not to do this and not to attempt to do this.
#  WHO GRANTS THESE FREEDOMS ?
#  10) The creators of this software are the original developer, and anyone listed as being a member of the Endwall Development Team, as well as ancillary contributors, and user modifiers and developers of the software. 
#  11) The aformentioned freedoms of use listed in sections 4),5),6),and 7) are granted by the creators of this software and the Endwall Development Team to any qualifying user listed in section 1) and 
#      comporting with any restrictions and qualifications mentioned in sections 2), 3), 8), 9), 10) and 11) of this LICENSE AGREEMENT.
#  WHAT RELATIONSHIP DO THE USERS HAVE WITH THE CREATORS OF THE SOFTWARE ?
#  12)  This software is distributed without any warranty and without any guaranty and the creators do not imply anything about its usefulness or efficacy.
#  13)  If the user suffers or sustains financial loss, informational loss, material loss, physical loss or data loss as a result of using, running, or modifying this software 
#       the user agrees that they will hold the creators of this software, the "Endwall Development Team", and the programers involved in its creation, free from prosecution, 
#       free from indemnity, and free from liability, and will not attempt to seek restitution or renumeration for any such loss real or imagined.
#  END OF LICENSE AGREEMENT
##################################################################################################################################################################################
#  ADDITIONAL NOTES:
#  14)  If a user finds a significant flaw or makes a significant improvement to this software, please feel free to notify the original developers so that we may also
#       include your user improvement in the next release; users are not obligated to do this, but we would enjoy this courtesy tremendously.
#
#  15)  Sections 0) a) 0) b) and 1) a) are sufficient for use; however sections 1) b) through 1) h) are presented to clarify 1 a) and to enforce non-discrimination and non-exlusion of use.  
#       For example some people may choose to redefine the meaning of the words "person" "human being" or "sentient individual" to exclude certain types of people.
#       This would be deemed unacceptable and is specifically rejected by the enumeration presented.  If the wording presented is problematic please contact us and suggest a change,
#       and it will be taken into consideration.  
#################################################################################################################################################################################
 
#####################################################        BEGINNING OF PROGRAM      #####################################################################################
##  get input list from shell argument 

Lunsort=$1
Punsort=$2
nargs="$#"

# randomly sort these lists
sort -R $Lunsort > temp1.srt
list=temp1.srt


#main loop to select random user agent
for link in $(cat "$list" ); do  
# pick a random user agent
n=$( expr $(head -c2 /dev/urandom | od -A n -i) % 70  | awk '{print $1}')
# set the user agent
#echo "$n"
if [ "$n" -le "5" ]
then 
UA="Mozilla/5.0 (Windows NT 6.1; rv:4$n.0) Gecko/20100101 Firefox/4$n.0"
else 
 case $n in 
 ( 6 )  UA="Mozilla/5.0 (Windows NT 6.1; rv:38.0) Gecko/20100101 Firefox/38.0" ;;
 ( 7 )  UA="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0" ;;
 ( 8 )  UA="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 9 )  UA="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 10 ) UA="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 11 ) UA="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 12 ) UA="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 13 ) UA="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 14 ) UA="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 15 ) UA="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 16 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 17 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 18 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 19 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 20 ) UA="Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 21 ) UA="Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 22 ) UA="Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 23 ) UA="Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 24 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 25 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 26 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 27 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 28 ) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 29 ) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 30 ) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 31 ) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 32 ) UA="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" ;;
 ( 33 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" ;;
 ( 34 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" ;;
 ( 35 ) UA="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;
 ( 36 ) UA="Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;
 ( 37 ) UA="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;
 ( 38 ) UA="Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;
 ( 39 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:41.0) Gecko/20100101 Firefox/41.0" ;;
 ( 40 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0" ;;
 ( 41 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0" ;;
 ( 42 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:44.0) Gecko/20100101 Firefox/44.0" ;;
 ( 43 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0) Gecko/20100101 Firefox/45.0" ;;
 ( 44 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:46.0) Gecko/20100101 Firefox/46.0" ;;
 ( 45 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" ;;
 ( 46 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" ;;
 ( 47 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;          
 ( 48 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36" ;;          
 ( 49 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.39 (KHTML, like Gecko) Version/9.0 Safari/601.1.39" ;;
 ( 50 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/601.2.4 (KHTML, like Gecko) Version/9.0.1 Safari/601.2.4" ;;
 ( 51 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/601.4.2 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.2" ;;
 ( 52 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/601.4.4 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.4" ;;
 ( 53 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" ;;
 ( 54 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/602.1.25 (KHTML, like Gecko) Version/9.1.1 Safari/601.6.10" ;;
 ( 55 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/601.6.14 (KHTML, like Gecko) Version/9.1.1 Safari/601.6.14" ;;
 ( 56 ) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12) AppleWebKit/602.1.18 (KHTML, like Gecko) Version/9.2 Safari/602.1.18" ;;
 ( 57 ) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A4325c Safari/601.1" ;;
 ( 58 ) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B5110e Safari/601.1" ;;
 ( 59 ) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13D15 Safari/601.1" ;;
 ( 60 ) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E237 Safari/601.1" ;;
 ( 61 ) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E238 Safari/601.1" ;;
 ( 62 ) UA="Mozilla/5.0 (iPad; CPU OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A344 Safari/601.1" ;;
 ( 63 ) UA="Mozilla/5.0 (iPad; CPU OS 9_0_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A404 Safari/601.1" ;;
 ( 64 ) UA="Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13C75 Safari/601.1" ;;
 ( 65 ) UA="Mozilla/5.0 (iPad; CPU OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1" ;;
 ( 66 ) UA="Mozilla/5.0 (iPad; CPU OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E238 Safari/601.1" ;;
 ( 67 ) UA="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)" ;;
 ( 68 ) UA="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)" ;;
 ( 69 ) UA="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)" ;;
 
 esac
fi
echo "$UA"

# generate a random number time delay
delay=$( expr 20 + $(head -c 2 /dev/urandom | od -A n -i) % 180 | awk '{print $1}')
echo "Delaying download for "$delay" seconds"
# wait by delay time
sleep "$delay"

echo "Downloading "$link""
# initiate download and change user agent

if [ "$nargs" -eq 2 ]
then
  # randomly sort proxies
  sort -R $Punsort > temp2.srt
  proxies=temp2.srt 
  n=$( expr $(head -c2 /dev/urandom | od -A n -i) % 3  | awk '{print $1}')
  # load the random proxy
    k="0"
    for url in $(cat $proxies);do
    if [ $k -eq $n ]
    then
     Prxy="$url"
    fi
    k=$( expr $k + 1 )
    done
  echo "Random Proxy is" "$Prxy" 
  # initiate download + tor + random UA + proxy
  torsocks youtube-dl --user-agent "$UA" --proxy "$Prxy" "$link" 
  rm $proxies
else 
  # initate download +tor + random agent - proxy 
  torsocks youtube-dl --user-agent "$UA" "$link" 
fi

done
# sometimes the download cuts off so don't delete the file until its all done
rm "$list"
exit 0
#########################################################        END OF PROGRAM         ######################################################################################
 
