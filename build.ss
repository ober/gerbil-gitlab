#!/usr/bin/env gxi
;; -*- Gerbil -*-

(import :std/build-script)

(defbuild-script
  '("gitlab/client"
    (static-exe:
     "gitlab/gitlab"
     "-cc-options"
     "-I/usr/pkg/include"
     "-ld-options"
     "-lpthread -lyaml -lz -L/usr/local/lib -lssl -L/usr/lib64 -L/usr/pkg/lib")))
