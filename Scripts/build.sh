
#!/bin/bash

docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift:5.3.1-amazonlinux2 \
    swift build --product ToDoList-API -c release -Xswiftc -static-stdlib
