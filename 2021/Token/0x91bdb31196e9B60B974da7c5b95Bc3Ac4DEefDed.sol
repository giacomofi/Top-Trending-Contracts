['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.3;\n', '\n', 'import "./Vinyl.sol";\n', 'import "./SafeMath.sol";\n', 'import "./Ownable.sol";\n', '\n', 'contract Airdrop is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    VINYL vinyl;\n', '\n', '    constructor(address _vinyl) {\n', '        vinyl = VINYL(_vinyl);\n', '    }\n', '\n', '    function airdrop(uint256 amount, address[] calldata users, uint256[] calldata numOwned) public onlyOwner {\n', '        vinyl.transferFrom(_msgSender(), address(this), amount);\n', '        require(users.length == numOwned.length, "Array lengths must match.");\n', '        uint256 total = 0;\n', '        for (uint i = 0; i < numOwned.length; i++)\n', '            total = total.add(numOwned[i]);\n', '        uint256 remaining = amount;\n', '        uint256 rate = amount.div(total);\n', '        for (uint i = 0; i < users.length; i++) {\n', '            uint256 sent;\n', '            if (i < users.length - 1)\n', '                sent = rate.mul(numOwned[i]);\n', '            else\n', '                sent = remaining;\n', '            vinyl.transferFrom(address(this), users[i], sent);\n', '            remaining = remaining.sub(sent);\n', '        }\n', '    }\n', '}']