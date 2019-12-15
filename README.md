# bash_intuivo_cli
Bash Utitilies for those to like to program using bash.


# Install

Clone this repo

Linux:
```
# Download
cd $HOME
mkdir -p $HOME/bin/clis
git clone https://github.com/zeusintuivo/bash_intuivo_cli.git

# Install as symlinks
cd $HOME/bin/clis/bash_intuivo_cli

# Execute linker to make scripts available
bash link_folder_scripts

```



# Use


`ü`  --  Searches words inside docs returning an iTerm friendly, colored, response, ready to CMND or CTRL click to edit right away
```
ü password | ü .html | ü hyper.      # This searches in all the documents, then pipes and searches from the result set all .html" then pipes and searches "hyper"
```

`ø`  --  Same as ü but without  (grep -v)
```
ü zeus | ø clone                     # This ü searches everything that says zeus then pipes the results and ø (ohne German for without) removes "clone" from the result
```

`ö`  -- Finds files with names all subdirectories
```
ö clone                              # This ö finds all the files that the name have "clone" word in it.
```

`äö` -- Replaces words inside files. Edit in place
```
äö zeus powerful                      # This äö will find all files with "zeus" and replace with "powerful." So no need to edit them.
```


`cüt` -- Removes content from the pipe passed to it
```
ü zeus | cüt zeus                    # This ü will find all files with "zeus" pipe the result to cüt which will remove the word "zeus" from the result set.
```
