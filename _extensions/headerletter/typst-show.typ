#show: doc => custom-letter(
$if(image-dir)$
  image-dir: "$image-dir$",
$endif$
$if(header-image)$
  header-image: "$header-image$",
$endif$
$if(signature-image)$
  signature-image: "$signature-image$",
$endif$
$if(sender-name)$
  sender-name: [$sender-name$],
$endif$
$if(sender-title)$
  sender-title: [$sender-title$],
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(recipient)$
  recipient: [$recipient$],
$endif$
$if(recipient-address)$
  recipient-address: [$recipient-address$],
$endif$
$if(subject)$
  subject: [$subject$],
$endif$
  doc,
)
