#  Some approach to improve performance


1. Using Operation to load JSON data and image. The operation will be running in the background to not block user interface.
2. Cancel image download operation when user scroll the table view, in case image download operation not start yet.
3. Cache image to reuse later, do not need to retrieve image again from URL
