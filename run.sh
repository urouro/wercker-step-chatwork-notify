if [ ! -n "$WERCKER_CHATWORK_NOTIFY_TOKEN" ]; then
  error 'Please specify token property'
  exit 1
fi

if [ ! -n "$WERCKER_CHATWORK_NOTIFY_ROOM_ID" ]; then
  error 'Please specify room_id property'
  exit 1
fi

if [ ! -n "$WERCKER_CHATWORK_NOTIFY_FAILED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_CHATWORK_NOTIFY_FAILED_MESSAGE="[info][title]Build failed (devil)[/title]$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME ($WERCKER_GIT_BRANCH)\nby $WERCKER_STARTED_BY\n$WERCKER_BUILD_URL[/info]"
  else
    export WERCKER_CHATWORK_NOTIFY_FAILED_MESSAGE="[info][title]Deploy failed (devil)[/title]$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME ($WERCKER_GIT_BRANCH)\nto $WERCKER_DEPLOYTARGET_NAME\nby $WERCKER_STARTED_BY\n$WERCKER_DEPLOY_URL[/info]"
  fi
fi

if [ ! -n "$WERCKER_CHATWORK_NOTIFY_PASSED_MESSAGE" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_CHATWORK_NOTIFY_PASSED_MESSAGE="[info][title]Build passed :D[/title]$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME ($WERCKER_GIT_BRANCH)\nby $WERCKER_STARTED_BY\n$WERCKER_BUILD_URL[/info]"
  else
    export WERCKER_CHATWORK_NOTIFY_PASSED_MESSAGE="[info][title]Deploy passed :D[/title]$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME ($WERCKER_GIT_BRANCH)\nto $WERCKER_DEPLOYTARGET_NAME\nby $WERCKER_STARTED_BY\n$WERCKER_DEPLOY_URL[/info]"
  fi
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  message=`echo -e "$WERCKER_CHATWORK_NOTIFY_PASSED_MESSAGE"`
else
  message=`echo -e "$WERCKER_CHATWORK_NOTIFY_FAILED_MESSAGE"`
fi

result=`curl -s -X POST \
  -H "X-ChatWorkToken:$WERCKER_CHATWORK_NOTIFY_TOKEN" \
  -d "body=$message" \
  "https://api.chatwork.com/v2/rooms/$WERCKER_CHATWORK_NOTIFY_ROOM_ID/messages" \
  --output "$WERCKER_STEP_TEMP/result.txt" \
  --write-out "%{http_code}"`

if [ "$result" = "200" ]; then
  success "Finished successfully!"
else
  echo -e "`cat $WERCKER_STEP_TEMP/result.txt`"
  fail "Finished Unsuccessfully."
fi
