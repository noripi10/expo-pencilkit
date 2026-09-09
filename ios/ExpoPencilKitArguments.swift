import ExpoModulesCore

/**
 Options to use when clear draw
 */
internal struct CreaDrawOptions: Record {
  @Field
  var force: Bool = true
}

/**
 Result of exportImage
*/
internal struct ExportImageResult: Record {
  @Field
  var path: String = ""

  @Field
  var base64: String = ""
}