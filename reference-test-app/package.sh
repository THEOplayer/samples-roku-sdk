#! /bin/bash -e
if test -f ../env.sh; then
    echo "Loading environment from env.sh"
    source ../env.sh
else
    echo "No env.sh file found. Make sure to correctly set ROKU_HOST and ROKU_USERPASS. Continuing."
fi

if echo $ZIP_TOOL | grep "7zip"; then
    7z a -tzip app.zip * -x!*.md && cd .. && mv reference-test-app/app.zip .
else
    zip -q -r app.zip * && cd .. && mv reference-test-app/app.zip .
fi

curl --user rokudev:$ROKU_USERPASS --digest --silent --show-error --output /dev/null --write-out "Uploading zip: %{http_code}\n" \
        -F "mysubmit=Install" -F "archive=@app.zip" http://$ROKU_HOST/plugin_install

rm -f app.zip
cd reference-test-app

echo "The app has been installed"
