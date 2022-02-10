['pragma solidity 0.4.24;\n', 'pragma experimental "v0.5.0";\n', '\n', '\n', 'contract SRNTPriceOracle {\n', '    // If SRNT becomes more expensive than ETH, we will have to reissue smart-contracts\n', '    uint256 public SRNT_per_ETH = 10000;\n', '\n', '    address internal serenity_wallet = 0x47c8F28e6056374aBA3DF0854306c2556B104601;\n', '\n', '    function update_SRNT_price(uint256 new_SRNT_per_ETH) external {\n', '        require(msg.sender == serenity_wallet);\n', '\n', '        SRNT_per_ETH = new_SRNT_per_ETH;\n', '    }\n', '}']