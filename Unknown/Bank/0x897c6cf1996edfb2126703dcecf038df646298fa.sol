['pragma solidity ^0.4.15;\n', '\n', 'contract etherDelta {\n', '    function deposit() payable;\n', '    function withdraw(uint amount);\n', '    function depositToken(address token, uint amount);\n', '    function withdrawToken(address token, uint amount);\n', '    function balanceOf(address token, address user) constant returns (uint);\n', '    function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce);\n', '    function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount);\n', '    function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private;\n', '    function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);\n', '    function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);\n', '    function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s);\n', '}\n', '\n', 'contract Token {\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract TradersWallet {\n', '    \n', '    address public owner;\n', '    string public version;\n', '    etherDelta private ethDelta;\n', '    address public ethDeltaDepositAddress;\n', '    \n', '    // init the TradersWallet()\n', '    function TradersWallet() {\n', '        owner = msg.sender;\n', '        version = "ALPHA 0.1";\n', '        ethDeltaDepositAddress = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819;\n', '        ethDelta = etherDelta(ethDeltaDepositAddress);\n', '    }\n', '    \n', '    // default function\n', '    function() payable {\n', '        \n', '    }\n', '    \n', '    // standard erc20 token balance in wallet from specific token address\n', '    function tokenBalance(address tokenAddress) constant returns (uint) {\n', '        Token token = Token(tokenAddress);\n', '        return token.balanceOf(this);\n', '    }\n', '    \n', '    // standard erc20 transferFrom function\n', '    function transferFromToken(address tokenAddress, address sendTo, address sendFrom, uint256 amount) external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.transferFrom(sendTo, sendFrom, amount);\n', '    }\n', '    \n', '    // change owner this this trader wallet\n', '    function changeOwner(address newOwner) external {\n', '        require(msg.sender==owner);\n', '        owner = newOwner;\n', '    }\n', '    \n', '    // send ether to another wallet\n', '    function sendEther(address toAddress, uint amount) external {\n', '        require(msg.sender==owner);\n', '        toAddress.transfer(amount);\n', '    }\n', '    \n', '    // standard erc20 transfer/send function\n', '    function sendToken(address tokenAddress, address sendTo, uint256 amount) external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.transfer(sendTo, amount);\n', '    }\n', '    \n', '    // let the owner execute with data\n', '    function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r) {\n', '        require(msg.sender==owner);\n', '        require(_to.call.value(_value)(_data));\n', '        return 0;\n', '    }\n', '    \n', '    // get ether delta token balance from token address\n', '    function EtherDeltaTokenBalance(address tokenAddress) constant returns (uint) {\n', '        return ethDelta.balanceOf(tokenAddress, this);\n', '    }\n', '    \n', '    // withdraw a token from etherdelta\n', '    function EtherDeltaWithdrawToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.withdrawToken(tokenAddress, amount);\n', '    }\n', '    \n', '    // change etherdelta exchange address\n', '    function changeEtherDeltaDeposit(address newEthDelta) external {\n', '        require(msg.sender==owner);\n', '        ethDeltaDepositAddress = newEthDelta;\n', '        ethDelta = etherDelta(newEthDelta);\n', '    }\n', '    \n', '    // deposit tokens to etherdelta\n', '    function EtherDeltaDepositToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.depositToken(tokenAddress, amount);\n', '    }\n', '    \n', '    // approve etherdelta to take take a specific amount\n', '    function EtherDeltaApproveToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.approve(ethDeltaDepositAddress, amount);\n', '    }\n', '    \n', '    // deposit ether to etherdelta\n', '    function EtherDeltaDeposit(uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.deposit.value(amount)();\n', '    }\n', '    \n', '    // withdraw ether from etherdelta\n', '    function EtherDeltaWithdraw(uint amount) external {\n', '        require(msg.sender==owner);\n', '        ethDelta.withdraw(amount);\n', '    }\n', '    \n', '    // destroy this wallet and send all ether to sender\n', '    // THIS DOES NOT INCLUDE ERC20 TOKENS\n', '    function kill() {\n', '        require(msg.sender==owner);\n', '        suicide(msg.sender);\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.15;\n', '\n', 'contract etherDelta {\n', '    function deposit() payable;\n', '    function withdraw(uint amount);\n', '    function depositToken(address token, uint amount);\n', '    function withdrawToken(address token, uint amount);\n', '    function balanceOf(address token, address user) constant returns (uint);\n', '    function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce);\n', '    function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount);\n', '    function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private;\n', '    function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);\n', '    function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint);\n', '    function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s);\n', '}\n', '\n', 'contract Token {\n', '    function totalSupply() constant returns (uint256 supply);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '}\n', '\n', '\n', 'contract TradersWallet {\n', '    \n', '    address public owner;\n', '    string public version;\n', '    etherDelta private ethDelta;\n', '    address public ethDeltaDepositAddress;\n', '    \n', '    // init the TradersWallet()\n', '    function TradersWallet() {\n', '        owner = msg.sender;\n', '        version = "ALPHA 0.1";\n', '        ethDeltaDepositAddress = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819;\n', '        ethDelta = etherDelta(ethDeltaDepositAddress);\n', '    }\n', '    \n', '    // default function\n', '    function() payable {\n', '        \n', '    }\n', '    \n', '    // standard erc20 token balance in wallet from specific token address\n', '    function tokenBalance(address tokenAddress) constant returns (uint) {\n', '        Token token = Token(tokenAddress);\n', '        return token.balanceOf(this);\n', '    }\n', '    \n', '    // standard erc20 transferFrom function\n', '    function transferFromToken(address tokenAddress, address sendTo, address sendFrom, uint256 amount) external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.transferFrom(sendTo, sendFrom, amount);\n', '    }\n', '    \n', '    // change owner this this trader wallet\n', '    function changeOwner(address newOwner) external {\n', '        require(msg.sender==owner);\n', '        owner = newOwner;\n', '    }\n', '    \n', '    // send ether to another wallet\n', '    function sendEther(address toAddress, uint amount) external {\n', '        require(msg.sender==owner);\n', '        toAddress.transfer(amount);\n', '    }\n', '    \n', '    // standard erc20 transfer/send function\n', '    function sendToken(address tokenAddress, address sendTo, uint256 amount) external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.transfer(sendTo, amount);\n', '    }\n', '    \n', '    // let the owner execute with data\n', '    function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r) {\n', '        require(msg.sender==owner);\n', '        require(_to.call.value(_value)(_data));\n', '        return 0;\n', '    }\n', '    \n', '    // get ether delta token balance from token address\n', '    function EtherDeltaTokenBalance(address tokenAddress) constant returns (uint) {\n', '        return ethDelta.balanceOf(tokenAddress, this);\n', '    }\n', '    \n', '    // withdraw a token from etherdelta\n', '    function EtherDeltaWithdrawToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.withdrawToken(tokenAddress, amount);\n', '    }\n', '    \n', '    // change etherdelta exchange address\n', '    function changeEtherDeltaDeposit(address newEthDelta) external {\n', '        require(msg.sender==owner);\n', '        ethDeltaDepositAddress = newEthDelta;\n', '        ethDelta = etherDelta(newEthDelta);\n', '    }\n', '    \n', '    // deposit tokens to etherdelta\n', '    function EtherDeltaDepositToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.depositToken(tokenAddress, amount);\n', '    }\n', '    \n', '    // approve etherdelta to take take a specific amount\n', '    function EtherDeltaApproveToken(address tokenAddress, uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        Token token = Token(tokenAddress);\n', '        token.approve(ethDeltaDepositAddress, amount);\n', '    }\n', '    \n', '    // deposit ether to etherdelta\n', '    function EtherDeltaDeposit(uint amount) payable external {\n', '        require(msg.sender==owner);\n', '        ethDelta.deposit.value(amount)();\n', '    }\n', '    \n', '    // withdraw ether from etherdelta\n', '    function EtherDeltaWithdraw(uint amount) external {\n', '        require(msg.sender==owner);\n', '        ethDelta.withdraw(amount);\n', '    }\n', '    \n', '    // destroy this wallet and send all ether to sender\n', '    // THIS DOES NOT INCLUDE ERC20 TOKENS\n', '    function kill() {\n', '        require(msg.sender==owner);\n', '        suicide(msg.sender);\n', '    }\n', '    \n', '}']