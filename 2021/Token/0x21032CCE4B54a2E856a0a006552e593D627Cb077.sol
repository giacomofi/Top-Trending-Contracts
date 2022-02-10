['// SPDX-License-Identifier: GPL-3.0\n', 'pragma solidity ^0.6.2;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', 'contract GOVIAirdrop is Ownable {\n', '\n', '    IERC20 public token;\n', '\n', '    event TokenDistributed(address[] addresses, uint256[] amounts);\n', '\n', '    constructor(IERC20 _token) public {\n', '        token = _token;\n', '    }\n', '\n', '      /**\n', '     * @dev admin function to bulk distribute to users after TVL threshold is reached\n', '     */\n', '    function distribute(address[] memory addresses, uint256[] memory amounts) public onlyOwner {\n', '        uint256 numAddresses = addresses.length;\n', '        uint256 numAmounts = amounts.length;\n', '        require(numAddresses == numAmounts, "Invalid parameters");\n', '\n', '        for (uint256 i = 0; i < addresses.length; i++) {\n', '            require(amounts[i] > 0, "Invalid transfer amount");\n', '            require(addresses[i] != address(0), "Invalid destination address");\n', '            require(token.transfer(addresses[i], amounts[i]), "Token transfer failed");\n', '        }\n', '\n', '        emit TokenDistributed(addresses, amounts);\n', '    }\n', '}']