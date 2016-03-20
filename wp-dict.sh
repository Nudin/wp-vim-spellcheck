#!/bin/bash

lang=${1:-'en'}

declare -A misspellcat
misspellcat[de]='Wikipedia%3AFalschschreibung'
misspellcat[en]='Redirects from misspellings'
misspellcat[ca]='Redireccions de noms incorrectes'
misspellcat[da]='Omdirigeringer af fejlstavninger'
misspellcat[hu]='Átirányítások hibás névről'
misspellcat[hu]='Wikipedia%3ARedirect voor spelfout'

# Get the list of articles
wget "https://dumps.wikimedia.org/${lang}wiki/latest/${lang}wiki-latest-all-titles-in-ns0.gz"
gunzip ${lang}wiki-latest-all-titles-in-ns0.gz
mv ${lang}wiki-latest-all-titles-in-ns0 wordlist

# Get list of misspelt words
if [[ "${misspellcat[$lang]}" != "" ]] ; then
    curl -d "language=${lang}&project=wikipedia&depth=3&categories=${misspellcat[$lang]}&negcats=&comb%5Bsubset%5D=1&atleast_count=0&ns%5B0%5D=1&show_redirects=both&templates_yes=&templates_any=&templates_no=&outlinks_yes=&outlinks_any=&outlinks_no=&edits%5Bbots%5D=both&edits%5Banons%5D=both&edits%5Bflagged%5D=both&before=&after=&max_age=&larger=&smaller=&minlinks=&maxlinks=&min_redlink_count=1&min_topcat_count=1&sortby=none&sortorder=ascending&format=csv&ext_image_data=1&file_usage_data=1&doit=Los%21&interface_language=de" https://tools.wmflabs.org/catscan2/catscan2.php | tail -n +3 | cut -d, -f1 | tr -d \" > misspell
else
    echo '' > misspell
fi

# Filter out Lemmas consisting of multiple words
grep -v '_' misspell > misspell2
grep -v '_' wordlist > wordlist2

# Remove the misspelt words
cat wordlist2 misspell2 | sort | uniq -u > wordlist3

# Remove lonlatin-characters
LC_ALL=${lang} grep '^[[:alpha:]]*$' wordlist3 > wordlist4
LC_ALL=${lang} grep '^[[:alpha:]]*$' misspell2 > misspell3

# Remove short words
grep -v '^.\{1,4\}$' wordlist4 > wordlist5
grep -v '^.\{1,4\}$' misspell3 > misspell4

# Compose final wordlist
echo -n "" > final_wordlist
echo "/encoding=utf-8" >> final_wordlist
cat wordlist5 >> final_wordlist
sed 's|$|/!|' misspell4 >> final_wordlist

# Generate Vim-Spellcheckfile
vim -u 'NONE' -c ":mkspell ${lang}wp final_wordlist" -c ':q'

rm wordlist*
rm misspell*
