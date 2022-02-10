['// SPDX-License-Identifier: UNLICENSED\n', '// ALL RIGHTS RESERVED\n', '// Unicrypt by SDDTech reserves all rights on this code. You may NOT copy these contracts.\n', '\n', '// This contract generates ENMT tokens and registers them in the Unicrypt ENMT MintFactory.\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '\n', 'import "./IERC20.sol";\n', 'import "./Ownable.sol";\n', '\n', 'import "./ENMT.sol";\n', 'import "./MintFactory.sol";\n', 'import "./TokenFees.sol";\n', '\n', '\n', 'interface IMintFactory {\n', '    function registerToken (address _tokenOwner, address _tokenAddress) external;\n', '    function tokenGeneratorsLength() external view returns (uint256);\n', '}\n', '\n', 'contract MintGenerator is Ownable {\n', '    \n', '    IMintFactory public MINT_FACTORY;\n', '    ITokenFees public TOKEN_FEES;\n', '    \n', '    constructor(address _mintFactory, address _tokenFees) {\n', '        MINT_FACTORY = IMintFactory(_mintFactory);\n', '        TOKEN_FEES = ITokenFees(_tokenFees);\n', '    }\n', '    \n', '    /**\n', '     * @notice Creates a new Token contract and registers it in the TokenFactory.sol.\n', '     */\n', '    \n', '    function createToken (\n', '      string memory name, \n', '      string memory symbol, \n', '      uint8 decimals, \n', '      uint256 totalSupply\n', '      ) public payable {\n', '          // Charge ETH fee for contract creation\n', "        require(msg.value == TOKEN_FEES.getFlatFee(), 'FEE NOT MET');\n", '        payable(TOKEN_FEES.getTokenFeeAddress()).transfer(TOKEN_FEES.getFlatFee());\n', '\n', '        IERC20 newToken = new ENMT(name, symbol, decimals, payable(msg.sender), totalSupply);\n', '        uint256 bal = newToken.balanceOf(address(this));\n', '        uint256 tsFee = bal * TOKEN_FEES.getTotalSupplyFee() / 1000;\n', '        newToken.transfer(TOKEN_FEES.getTokenFeeAddress(), tsFee);\n', '        newToken.transfer(msg.sender, bal - tsFee);\n', '        MINT_FACTORY.registerToken(msg.sender, address(newToken));\n', '    }\n', '}']