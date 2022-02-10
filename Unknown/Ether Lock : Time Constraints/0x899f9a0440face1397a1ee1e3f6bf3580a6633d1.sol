['pragma solidity ^0.4.9;\n', '\n', 'contract Token {\n', '  function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '}\n', '\n', 'contract RedemptionContract {\n', '  address public funder;        // the account able to fund with ETH\n', '  address public token;         // the token address\n', '  uint public exchangeRate;     // number of tokens per ETH\n', '\n', '  event Redemption(address redeemer, uint tokensDeposited, uint redemptionAmount);\n', '\n', '  function RedemptionContract(address _token, uint _exchangeRate) {\n', '    funder = msg.sender;\n', '    token = _token;\n', '    exchangeRate = _exchangeRate;\n', '  }\n', '\n', '  function () payable {\n', '    require(msg.sender == funder);\n', '  }\n', '\n', '  function redeemTokens(uint amount) {\n', '    // NOTE: redeemTokens will only work once the sender has approved \n', '    // the RedemptionContract address for the deposit amount \n', '    require(Token(token).transferFrom(msg.sender, this, amount));\n', '    \n', '    uint redemptionValue = amount / exchangeRate; \n', '    \n', '    msg.sender.transfer(redemptionValue);\n', '    \n', '    Redemption(msg.sender, amount, redemptionValue);\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.9;\n', '\n', 'contract Token {\n', '  function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '}\n', '\n', 'contract RedemptionContract {\n', '  address public funder;        // the account able to fund with ETH\n', '  address public token;         // the token address\n', '  uint public exchangeRate;     // number of tokens per ETH\n', '\n', '  event Redemption(address redeemer, uint tokensDeposited, uint redemptionAmount);\n', '\n', '  function RedemptionContract(address _token, uint _exchangeRate) {\n', '    funder = msg.sender;\n', '    token = _token;\n', '    exchangeRate = _exchangeRate;\n', '  }\n', '\n', '  function () payable {\n', '    require(msg.sender == funder);\n', '  }\n', '\n', '  function redeemTokens(uint amount) {\n', '    // NOTE: redeemTokens will only work once the sender has approved \n', '    // the RedemptionContract address for the deposit amount \n', '    require(Token(token).transferFrom(msg.sender, this, amount));\n', '    \n', '    uint redemptionValue = amount / exchangeRate; \n', '    \n', '    msg.sender.transfer(redemptionValue);\n', '    \n', '    Redemption(msg.sender, amount, redemptionValue);\n', '  }\n', '\n', '}']
