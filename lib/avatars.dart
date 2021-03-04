library avatars;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'sources/source.dart';
part 'sources/facebook.dart';
part 'sources/github.dart';
part 'sources/gravatar.dart';
part 'sources/instagram.dart';
part 'sources/network.dart';
part 'sources/placeholder.dart';

part 'widgets/avatar.dart';