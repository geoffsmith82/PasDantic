# PasDantic

**PasDantic** is an experimental **runtime data validation and schema library for Delphi**, inspired by Python’s **Pydantic**.

It allows you to declare validation rules directly on Delphi classes using **attributes**, then validate object instances at runtime using RTTI.

> PasDantic is **test-driven**.
> The **tests are the primary documentation** and define the supported behaviour.

---

## Why PasDantic?

Delphi is strongly typed at compile time, but many real-world inputs are not:

* JSON from APIs
* Configuration files
* AI / LLM structured output
* User input
* External systems with weak or shifting schemas

PasDantic fills this gap by providing **runtime validation** that is:

* Declarative
* Explicit
* Fail-fast
* Testable

The goal is similar to Pydantic:

> *Define what valid data looks like, then reject everything else.*

---

## Core Concepts

### 1. Models are plain Delphi classes

You define normal Delphi classes and annotate fields or properties with validation attributes.

```pascal
type
  TUser = class
  public
    [Required]
    [Email]
    Email: string;

    [UUID]
    Id: string;
  end;
```

No base class is required.

---

### 2. Validation happens at runtime

You validate an instance of a model using `ValidateModel`:

```pascal
var
  U: TUser;
  R: TValidationResult;
begin
  U := TUser.Create;
  try
    U.Email := 'user@example.com';
    U.Id := '{550E8400-E29B-41D4-A716-446655440000}';

    R := ValidateModel(U);

    if not R.IsValid then
      raise Exception.Create('Invalid data');
  finally
    U.Free;
  end;
end;
```

Validation inspects RTTI, finds attributes, and applies the appropriate rules.

---

### 3. Attributes define validation rules

PasDantic uses **attributes** to describe validation constraints.

#### Regex-based attributes

These inherit from `RegexAttribute`:

* `Email`
* `UUID` (supports `{}` and non-braced forms)
* `Hostname`
* etc.

Example:

```pascal
type
  TExample = class
  public
    [Email]
    Email: string;
  end;
```

---

#### Semantic (non-regex) attributes

Some data types **cannot be validated reliably with regex**.

For example:

* IPv6 (supports `::`, `::1`, compressed forms, IPv4-mapped addresses)

These use **parser-based validation** instead of regex, while keeping the same declarative style:

```pascal
type
  TNetwork = class
  public
    [IPv6]
    Address: string;
  end;
```

This mirrors Pydantic’s philosophy: *use the right tool, not regex everywhere*.

---

## Built-in Attributes (Current)

### String / Format

* `[Required]`
* `[Regex]`
* `[Email]`
* `[UUID]` (with or without `{}`)
* `[Hostname]`

### Network

* `[IPv4]`
* `[IPv6]`

  * accepts `::`
  * accepts `::1`
  * accepts full and compressed forms
  * rejects malformed addresses

---

## Validation Results

`ValidateModel` returns a `TValidationResult`:

```pascal
R.IsValid    // Boolean
R.Errors     // Collection of validation errors
```

This allows you to:

* Fail immediately
* Collect and report all errors
* Integrate with UI, logging, or APIs

---

## Tests = Documentation

PasDantic is **designed test-first**.

If you want to know:

* How an attribute behaves
* Which edge cases are supported
* What is considered valid vs invalid

👉 **Read the tests**

```
Tests/
  Test.PasDantic.RegexAttributes.pas
  Test.PasDantic.Validator.pas
  ...
```

If something is covered by a test, it is **supported behaviour**.

---

## Design Philosophy

* Prefer **clarity over cleverness**
* Avoid “magic” behaviour
* Let tests define the contract
* Avoid regex where semantics matter (e.g. IPv6)
* Be explicit rather than permissive

This is a Delphi library written *for Delphi developers*, not a direct port of Python code.

---

## Status

PasDantic currently is **experimental** and evolving.

* APIs may change
* Coverage is growing
* Has good test coverage so confident existing functionality works as expected
* Backwards compatibility is *not* guaranteed yet

That said, behaviour covered by tests is considered stable.

---

## Roadmap (Indicative)

* Array / list validation
* Nested models
* Numeric ranges
* Default values
* Schema generation (JSON Schema / OpenAPI)
* Better error messages and paths
* LLM structured-output validation helpers

---

## License

MIT License.

---

## Acknowledgements

Inspired by Python’s **Pydantic**, but implemented in a way that fits Delphi’s type system, RTTI, and ecosystem.

