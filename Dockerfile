# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

ENV PATH="/app:${PATH}"
# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline

# Pay attention to the next line! Write your file name after `bin/`!
# For example: `RUN dart compile exe bin/your_file_name.dart ...`

RUN dart compile exe lib/main.dart -o lib/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/lib/server /app/lib/
COPY --from=build /app /app/
COPY --from=build /root /app/

# Start server.
EXPOSE 8080
CMD ["/app/lib/server"]
