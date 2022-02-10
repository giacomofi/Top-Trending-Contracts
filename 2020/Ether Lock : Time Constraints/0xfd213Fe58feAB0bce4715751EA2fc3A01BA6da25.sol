['// SPDX-License-Identifier: GPL-3.0\n', 'pragma solidity >0.6.99 <0.8.0;\n', '\n', 'contract Wallet {\n', '\n', '\taddress public architect;\n', '\taddress public owner;\n', '\taddress public relayer;\n', '\tuint public unlockStartDate;\n', '\tuint public unlockEndDate;\n', '\tuint createdAt;\n', '\tuint iterations;\n', '\tuint latestETHClaim = 0;\n', '\tuint latestTokenClaim = 0;\n', '\n', '\tevent Received(address from, uint amount);\n', '\tevent ClaimedETH(address to, uint amount);\n', '\tevent ClaimedToken(address tokenContract, address to, uint amount);\n', '\n', '\tmodifier onlyAllowed {\n', '\t\trequire(msg.sender == owner || msg.sender == relayer, "Not allowed.");\n', '\t\t_;\n', '\t}\n', '\n', '\tconstructor(\n', '\t\taddress _architect,\n', '\t\taddress _owner,\n', '\t\taddress _relayer,\n', '\t\tuint _iterations,\n', '\t\tuint _unlockStartDate,\n', '\t\tuint _unlockEndDate\n', '\t)\n', '\t\tpayable\n', '  {\n', '\t\trequire(_iterations > 0 && _unlockStartDate >= block.timestamp && _unlockEndDate >= _unlockStartDate, "Wrong parameters.");\n', '\t\tarchitect = _architect;\n', '\t\towner = _owner;\n', '\t\trelayer = _relayer;\n', '\t\titerations = _iterations;\n', '\t\tunlockStartDate = _unlockStartDate;\n', '\t\tunlockEndDate = _unlockEndDate;\n', '\t\tcreatedAt = block.timestamp;\n', '\t}\n', '\n', '\treceive ()\n', '\t\texternal\n', '\t\tpayable\n', '\t{\n', '    emit Received(msg.sender, msg.value);\n', '  }\n', '\n', '\tfunction info()\n', '\t\tpublic\n', '\t\tview\n', '\t\treturns(address, address, uint, uint, uint, uint, uint, uint, uint, uint)\n', '\t{\n', '\t  return (architect, owner, createdAt, unlockStartDate, unlockEndDate, iterations, currentIteration(), latestTokenClaim, latestETHClaim, address(this).balance);\n', '\t}\n', '\n', '\tfunction currentIteration()\n', '\t\tprivate\n', '\t\tview\n', '\t\treturns (uint)\n', '\t{\n', '\t\tif(block.timestamp >= unlockEndDate) {\n', '\t\t\treturn iterations;\n', '\t\t} else if(block.timestamp >= unlockStartDate) {\n', '\t\t\tuint i = iterations * (block.timestamp - unlockStartDate) / (unlockEndDate - unlockStartDate) + 1;\n', '\t\t\tif(i > iterations) {\n', '\t\t\t\treturn iterations;\n', '\t\t\t} else {\n', '\t\t\t\treturn i;\n', '\t\t\t}\n', '\t\t} else {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction claim(address _tokenContract) onlyAllowed public {\n', '\t\trequire(block.timestamp >= unlockStartDate, "Asset cannot be unlocked yet.");\n', '\t\tif(address(0) == _tokenContract) {\n', '\t\t\tclaimETH();\n', '\t\t} else {\n', '\t\t\tclaimToken(_tokenContract);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction claimETH() private {\n', '\t\trequire(latestETHClaim >= iterations || latestETHClaim < currentIteration(), "ETH cannot be unlocked yet.");\n', '\t\tuint amount = address(this).balance;\n', '\t\tif(block.timestamp < unlockEndDate && latestETHClaim < iterations) {\n', '\t\t\tamount = amount / (iterations - latestETHClaim);\n', '\t\t\tlatestETHClaim++;\n', '\t\t}\n', '\t\tpayable(owner).transfer(amount);\n', '    emit ClaimedETH(owner, amount);\n', '  }\n', '\n', '  function claimToken(address _tokenContract) private {\n', '\t\trequire(latestTokenClaim >= iterations || latestTokenClaim < currentIteration(), "Token cannot be unlocked yet.");\n', '\t\tIERC20 token = IERC20(_tokenContract);\n', '\t\tuint amount = token.balanceOf(address(this));\n', '\t\tif(block.timestamp < unlockEndDate && latestTokenClaim < iterations) {\n', '\t\t\tamount = amount / (iterations - latestTokenClaim);\n', '\t\t\tlatestTokenClaim++;\n', '\t\t}\n', '    token.transfer(owner, amount);\n', '    emit ClaimedToken(_tokenContract, owner, amount);\n', '  }\n', '}\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint);\n', '  function balanceOf(address account) external view returns (uint);\n', '  function transfer(address recipient, uint amount) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint);\n', '  function approve(address spender, uint amount) external returns (bool);\n', '  function transferFrom(address sender, address recipient, uint amount) external returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n']
['// SPDX-License-Identifier: GPL-3.0\n', 'pragma solidity >0.6.99 <0.8.0;\n', 'import "./Wallet.sol";\n', 'contract WalletFactory {\n', '\n', '\tmapping(address => address[]) wallets;\n', '\n', '\tevent Created(address wallet, address from, address to, uint iterations, uint unlockStartDate, uint unlockEndDate);\n', '\n', '\tfunction getWallets(address _user)\n', '  \tpublic\n', '  \tview\n', '  returns(address[] memory)\n', '  {\n', '  \treturn wallets[_user];\n', '\t}\n', '\n', '\tfunction newWallet(address _owner, address _relayer, uint _iterations, uint _unlockStartDate, uint _unlockEndDate)\n', '\t\tpublic\n', '\t\tpayable\n', '\t{\n', '\t\taddress wallet = address(new Wallet(msg.sender, _owner, _relayer, _iterations, _unlockStartDate, _unlockEndDate));\n', '    wallets[msg.sender].push(wallet);\n', '\n', '    if(msg.sender != _owner){\n', '      wallets[_owner].push(wallet);\n', '    }\n', '\n', '\t\tpayable(wallet).transfer(msg.value);\n', '\t\temit Created(wallet, msg.sender, _owner, _iterations, _unlockStartDate, _unlockEndDate);\n', '\t}\n', '}\n']
