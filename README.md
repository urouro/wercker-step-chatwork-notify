# Notify Chatwork [![wercker status](https://app.wercker.com/status/817f214037010ebd948e628f58c0724f/s "wercker status")](https://app.wercker.com/project/bykey/817f214037010ebd948e628f58c0724f)

A [wercker](http://wercker.com/) step to send a message to a Chatwork room

## Options
- `token` (required) Your Chatwork token
- `room-id` (required) The id of the Chatwork room
- `passed-message` (optional) The message which will be shown on a passed build or deploy.
- `failed-message` (optional) The message which will be shown on a failed build or deploy.

## Example
The following `wercker.yml`:

```yaml
build:
  after-steps:
    - heathrow/chatwork-notify:
        token: $CHATWORK_TOKEN
        room-id: id
```
