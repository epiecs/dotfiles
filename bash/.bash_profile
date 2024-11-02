# just load ~/.bashrc
# .bash_profile is loaded for interactive shells, .bashrc for non interactive
# I am not going to maintain duplicate files so I just let 1 load the other

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi