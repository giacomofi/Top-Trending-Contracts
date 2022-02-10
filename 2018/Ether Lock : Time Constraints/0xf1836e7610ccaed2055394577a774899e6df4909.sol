['pragma solidity ^0.4.18;\n', '\n', 'contract Token {\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool success);\n', '  function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract TokenPeg {\n', '  address public minimalToken;\n', '  address public signalToken;\n', '  bool public pegIsSetup;\n', '\n', '  event Configured(address minToken, address sigToken);\n', '  event SignalingEnabled(address exchanger, uint tokenCount);\n', '  event SignalingDisabled(address exchanger, uint tokenCount);\n', '\n', '  function TokenPeg() public {\n', '    pegIsSetup = false;\n', '  }\n', '\n', '  function setupPeg(address _minimalToken, address _signalToken) public {\n', '    require(!pegIsSetup);\n', '    pegIsSetup = true;\n', '\n', '    minimalToken = _minimalToken;\n', '    signalToken = _signalToken;\n', '\n', '    Configured(_minimalToken, _signalToken);\n', '  }\n', '\n', '  function tokenFallback(address _from, uint _value, bytes /*_data*/) public {\n', '    require(pegIsSetup);\n', '    require(msg.sender == signalToken);\n', '    giveMinimalTokens(_from, _value);\n', '  }\n', '\n', '  function convertMinimalToSignal(uint amount) public {\n', '    require(Token(minimalToken).transferFrom(msg.sender, this, amount));\n', '    require(Token(signalToken).transfer(msg.sender, amount));\n', '\n', '    SignalingEnabled(msg.sender, amount);\n', '  }\n', '\n', '  function convertSignalToMinimal(uint amount) public {\n', '    require(Token(signalToken).transferFrom(msg.sender, this, amount));\n', '  }\n', '\n', '  function giveMinimalTokens(address from, uint amount) private {\n', '    require(Token(minimalToken).transfer(from, amount));\n', '    \n', '    SignalingDisabled(from, amount);\n', '  }\n', '\n', '}']