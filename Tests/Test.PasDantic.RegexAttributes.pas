unit Test.PasDantic.RegexAttributes;

interface

uses
  DUnitX.TestFramework,
  PasDantic.Validator,
  PasDantic.Attributes;

type
  { ---------- Email ---------- }

  TEmailTest = class
  public
    [Email]
    Email: string;
  end;

  { ---------- IPv4 ---------- }

  TIPv4Test = class
  public
    [IPv4]
    Address: string;
  end;

  { ---------- IPv6 ---------- }

  TIPv6Test = class
  public
    [IPv6]
    Address: string;
  end;

  { ---------- UUID ---------- }

  TUUIDTest = class
  public
    [UUID]
    Id: string;
  end;

  [TestFixture]
  TPasDanticCommonRegexAttributeTests = class
  public
    // Email
    [Test] procedure Email_Pass_Com;
    [Test] procedure Email_Pass_ComAu;
    [Test] procedure Email_Fail;

    // IPv4
    [Test] procedure IPv4_Pass;
    [Test] procedure IPv4_Fail;

    // IPv6
    [Test] procedure IPv6_Pass_Full;
    [Test] procedure IPv6_Pass_Shortened;
    [Test] procedure IPv6_Fail;
    [Test] procedure IPv6_PassLocal1;
    [Test] procedure IPv6_withIPv4;
    [Test] procedure IPv6_withIPv4Invalid;
    [Test] procedure IPv6_PassAllZeros;
    // UUID
    [Test] procedure UUID_Pass;
    [Test] procedure UUID_Fail;
    [Test] procedure UUID_Pass_WithBraces;
    [Test] procedure UUID_Fail_MismatchedBraces;
  end;

implementation

{ ---------- Email ---------- }

procedure TPasDanticCommonRegexAttributeTests.Email_Pass_Com;
var
  U: TEmailTest;
  R: TValidationResult;
begin
  U := TEmailTest.Create;
  try
    U.Email := 'user@example.com';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.Email_Pass_ComAu;
var
  U: TEmailTest;
  R: TValidationResult;
begin
  U := TEmailTest.Create;
  try
    U.Email := 'user@example.com.au';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.Email_Fail;
var
  U: TEmailTest;
  R: TValidationResult;
begin
  U := TEmailTest.Create;
  try
    U.Email := 'not-an-email';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

{ ---------- IPv4 ---------- }

procedure TPasDanticCommonRegexAttributeTests.IPv4_Pass;
var
  U: TIPv4Test;
  R: TValidationResult;
begin
  U := TIPv4Test.Create;
  try
    U.Address := '192.168.1.100';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv4_Fail;
var
  U: TIPv4Test;
  R: TValidationResult;
begin
  U := TIPv4Test.Create;
  try
    U.Address := '999.999.999.999';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

{ ---------- IPv6 ---------- }

procedure TPasDanticCommonRegexAttributeTests.IPv6_Pass_Full;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '2001:0DB8:85A3:0000:0000:8A2E:0370:7334';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_Pass_Shortened;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '2001:db8:85a3::8a2e:370:7334';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_Fail;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '2001:::7334';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_PassLocal1;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '::1';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_withIPv4;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '::ffff:192.168.1.1';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_withIPv4Invalid;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '::ffff:192.168.1.999';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.IPv6_PassAllZeros;
var
  U: TIPv6Test;
  R: TValidationResult;
begin
  U := TIPv6Test.Create;
  try
    U.Address := '::';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

{ ---------- UUID ---------- }

procedure TPasDanticCommonRegexAttributeTests.UUID_Pass;
var
  U: TUUIDTest;
  R: TValidationResult;
begin
  U := TUUIDTest.Create;
  try
    U.Id := '550E8400-E29B-41D4-A716-446655440000';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.UUID_Fail;
var
  U: TUUIDTest;
  R: TValidationResult;
begin
  U := TUUIDTest.Create;
  try
    U.Id := 'not-a-uuid';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.UUID_Pass_WithBraces;
var
  U: TUUIDTest;
  R: TValidationResult;
begin
  U := TUUIDTest.Create;
  try
    U.Id := '{550E8400-E29B-41D4-A716-446655440000}';

    R := ValidateModel(U);

    Assert.IsTrue(R.IsValid);
  finally
    U.Free;
  end;
end;

procedure TPasDanticCommonRegexAttributeTests.UUID_Fail_MismatchedBraces;
var
  U: TUUIDTest;
  R: TValidationResult;
begin
  U := TUUIDTest.Create;
  try
    U.Id := '{550E8400-E29B-41D4-A716-446655440000';

    R := ValidateModel(U);

    Assert.IsFalse(R.IsValid);
  finally
    U.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TPasDanticCommonRegexAttributeTests);


end.
