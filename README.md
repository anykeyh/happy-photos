#happy-photos

Provides a *very simple* webapp to share photos from event between users.

When I went to the wedding of my best friend, every body takes pictures.
I didn't find a simple to use tool to share and upload pictures of event
between people (picasa need registration for example). Now it's done.

You can also generate a tar file of every pictures (but it can be long...)

Note than all texts are in french and static in the code.

##How to use it?

Just copy `config/happy_photos.sample.yml` to `config/happy_photos.yml`,
then update password.
Send the password to everybody, and wait them until they upload photos!

They are  two rights mode: uploader which can upload and tag pictures,
and administrator, which can also delete pictures.

Due to the specific task of the application (provide a platform for the
wedding of my friend), the photos are always sorted by shot date (it use
EXIM metatag).