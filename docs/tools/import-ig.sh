#!/bin/bash

echo "INSTAGRAM TO JEKYLL IMPORTER"

echo "[?] Which Instagram post would you like to import?"
read post

echo "[?] What is the title of your new post?"
read title

echo "[?] What should the publish date of the post be? (y-m-d)"
read date

echo "[?] What should the categories of the post be? [bikepacking, race]"
read categories

# Format filename
fileName=$(echo "$date-$title" | iconv -t ascii//TRANSLIT | sed -E s/[^a-zA-Z0-9]+/-/g | sed -E s/^-+\|-+$//g | tr A-Z a-z)
path="_posts/$fileName.md"

# Show confirmation on screen
echo "Starting import"
echo "--> importing post with id '$post'"
echo "--> output file: $fileName.md"

# Download the images
echo "--> import image"
wget --output-document="assets/img/${fileName}.jpg" "https://www.instagram.com/p/$post/media?size=l"

# Output markdown file
content="---
layout: post
title:  '$title'
date:   $date
instagram_id: $post
categories: $categories
image: assets/img/${fileName}.jpg
#gif: mygif
description: ''
customexcerpt: ''
---
![$title](/assets/img/${fileName}.jpg)"

echo "$content" >> "$path"

# Download IG text
curl -s "https://api.instagram.com/oembed/?url=http://instagr.am/p/$post" | jq {title}.title  >> "$path"

echo "IMPORT COMPLETE"
