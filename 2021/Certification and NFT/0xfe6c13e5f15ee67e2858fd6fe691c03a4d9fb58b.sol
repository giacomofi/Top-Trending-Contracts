['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'import "ERC20.sol";\n', 'import "Ownable.sol";\n', '\n', '\n', 'contract LitionVesting is Ownable {\n', '    ERC20 usdcToken = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    address beneficiary = 0xd1c99dAf0D3706FfB502E8fcD3663719c879caf9;\n', '    uint256 public totalClaimed;\n', '    \n', '    uint256 JUNE_2021 = 1622499891;\n', '    uint256 SEPTEMBER_2021 = 1630448691;\n', '    uint256 DECEMBER_2021 = 1638314691;\n', '    uint256 MARCH_2022 = 1646090691;\n', '    \n', '    uint256 maxDateToClaimUnallocated;\n', '    \n', '    event TokensClaimed(uint256 _total);\n', '\n', '    function claimTokens() external\n', '    {\n', '        require(msg.sender == beneficiary, "Invalid caller");\n', '        \n', '        uint256 tokensToClaim = getTotalToClaimOnDate(block.timestamp);\n', '        require(tokensToClaim > 0, "Nothing to claim");\n', '        \n', '        totalClaimed += tokensToClaim;\n', '        \n', '        require(usdcToken.transfer(msg.sender, tokensToClaim), "Insufficient balance in vesting contract");\n', '        emit TokensClaimed(tokensToClaim);\n', '    }\n', '    \n', '    function _claimUnallocated(uint256 _total) external onlyOwner {\n', '        require(block.timestamp < maxDateToClaimUnallocated, "Option not available anymore");\n', '        \n', '        require(usdcToken.transfer(msg.sender, _total), "Insufficient balance in vesting contract");\n', '    }\n', '    \n', '    function getTotalToClaimOnDate(uint256 _date) public view returns (uint256) {\n', '        if (_date < JUNE_2021) {\n', '            return 0;\n', '        }\n', '        if (_date < SEPTEMBER_2021) {\n', '            return 75000 * 1e6 - totalClaimed;\n', '        }\n', '        if (_date < DECEMBER_2021) {\n', '            return 150000 * 1e6 - totalClaimed;\n', '        }\n', '        if (_date < MARCH_2022) {\n', '            return 225000 * 1e6 - totalClaimed;\n', '        }\n', '        return 300000 * 1e6 - totalClaimed;\n', '    }\n', '    \n', '    constructor() {\n', '        maxDateToClaimUnallocated = block.timestamp + 30 days;\n', '    }\n', '}']