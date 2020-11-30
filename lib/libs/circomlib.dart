import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:hermez_plugin/utils/structs.dart';
import 'package:hermez_plugin/utils/uint8_list_utils.dart';

///////////////////////////////////////////////////////////////////////////////
// Load the library
///////////////////////////////////////////////////////////////////////////////

final DynamicLibrary nativeExampleLib = Platform.isAndroid
    ? DynamicLibrary.open("libbabyjubjub.so")
    : DynamicLibrary.process();

typedef PackSignatureFuncNative = Pointer<Uint8> Function(Pointer<Uint8>);
typedef PackSignatureFunc = Pointer<Uint8> Function(Pointer<Signature>);

// babyJub.unpackPoint
// Result<Signature,String>

// eddsa.packSignature -> pack_signature
/*typedef PackSignatureFunc = Pointer<Uint8> Function(Pointer<Structs.Signature>);
typedef PackSignatureFuncNative = Pointer<Uint8> Function(
    Pointer<Structs.Signature>);
final PackSignatureFunc packSignature = nativeExampleLib
    .lookup<NativeFunction<PackSignatureFuncNative>>("pack_signature")
    .asFunction();*/
/*typedef PackSignatureFunc = Pointer<Uint8> Function(Pointer<Uint8>);
typedef PackSignatureFuncNative = Pointer<Uint8> Function(Pointer<Uint8>);
final PackSignatureFunc packSignature = nativeExampleLib
    .lookup<NativeFunction<PackSignatureFuncNative>>("pack_signature")
    .asFunction();

// eddsa.unpackSignature -> unpack_signature
typedef UnpackSignatureFunc = Pointer<Structs.Signature> Function(
    Pointer<Uint8>);
typedef UnpackSignatureFuncNative = Pointer<Structs.Signature> Function(
    Pointer<Uint8>);
final UnpackSignatureFunc unpackSignature = nativeExampleLib
    .lookup<NativeFunction<UnpackSignatureFuncNative>>("unpack_signature")
    .asFunction();

// eddsa.packPoint -> pack_point
/*typedef PackPointFunc = Pointer<Uint8> Function(Pointer<Structs.Point>);
typedef PackPointFuncNative = Pointer<Uint8> Function(Pointer<Structs.Point>);
final PackPointFunc packPoint = nativeExampleLib
    .lookup<NativeFunction<PackPointFuncNative>>("pack_point")
    .asFunction();*/
typedef PackPointFunc = Pointer<Uint8> Function(Pointer<Uint8>);
typedef PackPointFuncNative = Pointer<Uint8> Function(Pointer<Uint8>);
final PackPointFunc packPoint = nativeExampleLib
    .lookup<NativeFunction<PackPointFuncNative>>("pack_point")
    .asFunction();

// eddsa.unpackPoint -> unpack_point
typedef UnpackPointFunc = Pointer<Uint8> Function(Pointer<Uint8>);
typedef UnpackPointFuncNative = Pointer<Uint8> Function(Pointer<Uint8>);
final UnpackPointFunc unpackPoint = nativeExampleLib
    .lookup<NativeFunction<UnpackPointFuncNative>>("unpack_point")
    .asFunction();

// eddsa.prv2pub -> prv2pub
typedef Prv2pubFunc = Pointer<Structs.Point> Function(Pointer<Uint8>);
typedef Prv2pubFuncNative = Pointer<Structs.Point> Function(Pointer<Uint8>);
final Prv2pubFunc prv2pub = nativeExampleLib
    .lookup<NativeFunction<Prv2pubFuncNative>>("prv2pub")
    .asFunction();

// circomlib.poseidon -> hashPoseidon
typedef hashPoseidonFunc = Pointer<Structs.Point> Function(Pointer<Uint8>);
typedef hashPoseidonFuncNative = Pointer<Structs.Point> Function(
    Pointer<Uint8>);
final hashPoseidonFunc hashPoseidon = nativeExampleLib
    .lookup<NativeFunction<hashPoseidonFuncNative>>("hashPoseidon")
    .asFunction();

// circomlib.poseidon -> signPoseidon
/*typedef signPoseidonFunc = Pointer<Structs.Signature> Function(
    Pointer<Uint8>, Pointer<Utf8>);
typedef signPoseidonNative = Pointer<Structs.Signature> Function(
    Pointer<Uint8>, Pointer<Utf8>);
final signPoseidonFunc signPoseidon = nativeExampleLib
    .lookup<NativeFunction<signPoseidonNative>>("signPoseidon")
    .asFunction();*/
typedef signPoseidonFunc = Pointer<Uint8> Function(
    Pointer<Uint8>, Pointer<Utf8>);
typedef signPoseidonNative = Pointer<Uint8> Function(
    Pointer<Uint8>, Pointer<Utf8>);
final signPoseidonFunc signPoseidon = nativeExampleLib
    .lookup<NativeFunction<signPoseidonNative>>("signPoseidon")
    .asFunction();

// circomlib.poseidon -> poseidon
typedef verifyPoseidonFunc = Pointer<Uint8> Function(
    Pointer<Uint8>, Pointer<Utf8>);
typedef verifyPoseidonNative = Pointer<Uint8> Function(
    Pointer<Uint8>, Pointer<Utf8>);
final verifyPoseidonFunc verifyPoseidon = nativeExampleLib
    .lookup<NativeFunction<verifyPoseidonNative>>("verifyPoseidon")
    .asFunction();*/

class CircomLib {
  final DynamicLibrary lib = Platform.isAndroid
      ? DynamicLibrary.open("libbabyjubjub.so")
      : DynamicLibrary.process();
  //final DynamicLibrary lib;
  CircomLib(/*{@required this.lib}*/) {
    _packSignature = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "pack_signature")
        .asFunction();

    _unpackSignature = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "unpack_signature")
        .asFunction();

    _packPoint = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "pack_point")
        .asFunction();

    _unpackPoint = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "unpack_point")
        .asFunction();

    _hashPoseidon = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "hash_poseidon")
        .asFunction();

    _signPoseidon = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "sign_poseidon")
        .asFunction();

    _verifyPoseidon = lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>(
            "verify_poseidon")
        .asFunction();
  }

  Pointer<Uint8> Function(Pointer<Uint8>) _packSignature;
  Uint8List packSignature(Pointer<Uint8> signature) {
    final Uint8List buf = Uint8ArrayUtils.fromPointer(signature, 32);
    //leInt2Buff(compressedBigInt, 32);
    if (buf.length != 32) {
      throw new Error(/*'buf must be 32 bytes'*/);
    }
    //final Uint8List buf = Uint8ArrayUtils.fromPointer(signature, length);
    //final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _packSignature(buf);
    final Uint8List result = Uint8ArrayUtils.fromPointer(resultPtr, 32);
    return result;
  }

  Pointer<Uint8> Function(Pointer<Uint8>) _unpackSignature;
  Pointer<Uint8> unpackSignature(Uint8List buf) {
    final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _unpackSignature(ptr);
    return resultPtr.ref;
  }

  Pointer<Uint8> Function(Pointer<Uint8>) _packPoint;
  Uint8List packPoint(Pointer<Uint8> point) {
    final Uint8List buf = Uint8ArrayUtils.fromPointer(point, 32);
    //leInt2Buff(compressedBigInt, 32);
    if (buf.length != 32) {
      throw new Error(/*'buf must be 32 bytes'*/);
    }
    //final Uint8List buf = Uint8ArrayUtils.fromPointer(signature, length);
    //final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _packPoint(buf);
    final Uint8List result = Uint8ArrayUtils.fromPointer(resultPtr, 32);
    return result;
  }

  Pointer<Uint8> Function(Pointer<Uint8>) _unpackPoint;
  Point unpackPoint(Uint8List buf) {
    final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _unpackPoint(ptr);
    return resultPtr.ref;
  }

  // circomlib.poseidon -> hashPoseidon
  Pointer<Uint8> Function(Pointer<Uint8>) _hashPoseidon;
  Uint8 hashPoseidon(Uint8List buf) {
    final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _hashPoseidon(ptr);
    return resultPtr.ref;
  }

  // privKey.signPoseidon -> signPoseidon
  Pointer<Uint8> Function(Pointer<Uint8>) _signPoseidon;
  Point signPoseidon(Uint8List buf) {
    final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _signPoseidon(ptr);
    return resultPtr.ref;
  }

  // privKey.verifyPoseidon -> verifyPoseidon
  Pointer<Uint8> Function(Pointer<Uint8>) _verifyPoseidon;
  Point verifyPoseidon(Uint8List buf) {
    final ptr = Uint8ArrayUtils.toPointer(buf);
    final resultPtr = _verifyPoseidon(ptr);
    return resultPtr.ref;
  }

  /*
  * function packSignature(sig) {
    const R8p = babyJub.packPoint(sig.R8);
    const Sp = utils.leInt2Buff(sig.S, 32);
    return Buffer.concat([R8p, Sp]);
}

function unpackSignature(sigBuff) {
    return {
        R8: babyJub.unpackPoint(sigBuff.slice(0,32)),
        S: utils.leBuff2int(sigBuff.slice(32,64))
    };
}
  * */
}
