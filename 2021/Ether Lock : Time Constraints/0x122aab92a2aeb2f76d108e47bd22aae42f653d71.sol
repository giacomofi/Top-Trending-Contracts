['// SPDX-License-Identifier: GPL-3.0-only\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./Address.sol";\n', 'import "./IERC20.sol";\n', "import './TransferHelper.sol';\n", 'import "./ReentrancyGuard.sol";\n', '\n', 'contract YOLOPresale is ReentrancyGuard{\n', '\tusing SafeMath for uint256;\n', '\tusing Address for address;\n', '\tuint256 private constant rate = 3285700000000000;\n', '\tuint256 private constant presaleAmount = 16428500000000000000000;\n', '\taddress public immutable YoloToken;\n', '\taddress payable private immutable owner;\n', '\tbool public ended;\n', '\n', '\tevent PresaleEnded(uint256 timestamp);\n', '\n', '\tevent PresaleStart(uint256 timestamp);\n', '\n', '\tevent PurchasedToken(address indexed buyer, uint256 amount);\n', '\n', '\tconstructor(address _YoloToken) {\n', '\t\tended = false;\n', '\t\tYoloToken = _YoloToken;\n', '\t\towner = msg.sender;\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '        require(owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '\tfunction purchaseYoloToken() external payable nonReentrant returns (uint256) {\n', '\t\trequire(!ended, "The presale is ended");\n', '\t\trequire(msg.value > 0, "Invalid input ETH amount");\n', '\n', '\t\tuint256 currentBalance = IERC20(YoloToken).balanceOf(address(this));\n', '\t\trequire(currentBalance > 0, "The presale is ended");\n', '\t\tuint256 amount = msg.value.mul(10**18).div(rate);\n', '\n', '\t\tif (amount > currentBalance) {\n', '\t\t\tamount = currentBalance;\n', '\t\t}\n', '\n', '\t\tTransferHelper.safeTransfer(YoloToken, msg.sender, amount);\n', '\t\tmsg.sender.transfer(msg.value.sub(amount.mul(rate).div(10**18)));\n', '\n', '\t\temit PurchasedToken(msg.sender, amount);\n', '\t\treturn amount;\n', '\t}\n', '\n', '\tfunction presaleStart() external onlyOwner {\n', '\t\tTransferHelper.safeTransferFrom(YoloToken, msg.sender, address(this), presaleAmount);\n', '\t\temit PresaleStart(block.timestamp);\n', '\t}\n', '\n', '\tfunction presaleEnd() external onlyOwner {\n', '\t\trequire(!ended, "The presale is already ended");\n', '\n', '\t\tended = true;\n', '\n', '\t\towner.transfer(address(this).balance);\n', '\t\tuint256 currentBalance = IERC20(YoloToken).balanceOf(address(this));\n', '\t\tif (currentBalance > 0) {\n', '\t\t\tTransferHelper.safeTransfer(YoloToken, owner, currentBalance);\n', '\t\t}\n', '\n', '\t\temit PresaleEnded(block.timestamp);\n', '\t}\n', '}']