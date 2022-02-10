['/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity ^0.4.13;\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() public {\n', '        owner = msg.sender;\n', '        LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', '/// erc20.sol -- API for the ERC20 token standard\n', '\n', '// See <https://github.com/ethereum/EIPs/issues/20>.\n', '\n', '// This file likely does not meet the threshold of originality\n', '// required for copyright to apply.  As a result, this is free and\n', '// unencumbered software belonging to the public domain.\n', '\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract ERC20Events {\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '}\n', '\n', 'contract ERC20 is ERC20Events {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address guy) public view returns (uint);\n', '    function allowance(address src, address guy) public view returns (uint);\n', '\n', '    function approve(address guy, uint wad) public returns (bool);\n', '    function transfer(address dst, uint wad) public returns (bool);\n', '    function transferFrom(\n', '        address src, address dst, uint wad\n', '    ) public returns (bool);\n', '}\n', '\n', '/* Viewly main token sale contract, where contributors send ethers in order to\n', ' * later receive VIEW tokens (outside of this contract).\n', ' */\n', 'contract ViewlyMainSale is DSAuth, DSMath {\n', '\n', '    // STATE\n', '\n', '    uint public minContributionAmount = 5 ether; // initial min contribution amount\n', '    uint public maxTotalAmount = 4300 ether;     // initial min contribution amount\n', '    address public beneficiary;                  // address to collect contributed amount to\n', '    uint public startBlock;                      // start block of sale\n', '    uint public endBlock;                        // end block of sale\n', '\n', '    uint public totalContributedAmount;          // stores all contributions\n', '    uint public totalRefundedAmount;             // stores all refunds\n', '\n', '    mapping(address => uint256) public contributions;\n', '    mapping(address => uint256) public refunds;\n', '\n', '    bool public whitelistRequired;\n', '    mapping(address => bool) public whitelist;\n', '\n', '\n', '    // EVENTS\n', '\n', '    event LogContribute(address contributor, uint amount);\n', '    event LogRefund(address contributor, uint amount);\n', '    event LogCollectAmount(uint amount);\n', '\n', '\n', '    // MODIFIERS\n', '\n', '    modifier saleOpen() {\n', '        require(block.number >= startBlock);\n', '        require(block.number <= endBlock);\n', '        _;\n', '    }\n', '\n', '    modifier requireWhitelist() {\n', '        if (whitelistRequired) require(whitelist[msg.sender]);\n', '        _;\n', '    }\n', '\n', '\n', '    // PUBLIC\n', '\n', '    function ViewlyMainSale(address beneficiary_) public {\n', '        beneficiary = beneficiary_;\n', '    }\n', '\n', '    function() public payable {\n', '        contribute();\n', '    }\n', '\n', '\n', '    // AUTH-REQUIRED\n', '\n', '    function refund(address contributor) public auth {\n', '        uint amount = contributions[contributor];\n', '        require(amount > 0);\n', '        require(amount <= this.balance);\n', '\n', '        contributions[contributor] = 0;\n', '        refunds[contributor] += amount;\n', '        totalRefundedAmount += amount;\n', '        totalContributedAmount -= amount;\n', '        contributor.transfer(amount);\n', '        LogRefund(contributor, amount);\n', '    }\n', '\n', '    function setMinContributionAmount(uint minAmount) public auth {\n', '        require(minAmount > 0);\n', '\n', '        minContributionAmount = minAmount;\n', '    }\n', '\n', '    function setMaxTotalAmount(uint maxAmount) public auth {\n', '        require(maxAmount > 0);\n', '\n', '        maxTotalAmount = maxAmount;\n', '    }\n', '\n', '    function initSale(uint startBlock_, uint endBlock_) public auth {\n', '        require(startBlock_ > 0);\n', '        require(endBlock_ > startBlock_);\n', '\n', '        startBlock = startBlock_;\n', '        endBlock   = endBlock_;\n', '    }\n', '\n', '    function collectAmount(uint amount) public auth {\n', '        require(this.balance >= amount);\n', '\n', '        beneficiary.transfer(amount);\n', '        LogCollectAmount(amount);\n', '    }\n', '\n', '    function addToWhitelist(address[] contributors) public auth {\n', '        require(contributors.length != 0);\n', '\n', '        for (uint i = 0; i < contributors.length; i++) {\n', '          whitelist[contributors[i]] = true;\n', '        }\n', '    }\n', '\n', '    function removeFromWhitelist(address[] contributors) public auth {\n', '        require(contributors.length != 0);\n', '\n', '        for (uint i = 0; i < contributors.length; i++) {\n', '          whitelist[contributors[i]] = false;\n', '        }\n', '    }\n', '\n', '    function setWhitelistRequired(bool setting) public auth {\n', '        whitelistRequired = setting;\n', '    }\n', '\n', '    function setOwner(address owner_) public auth {\n', '        revert();\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_) public auth {\n', '        revert();\n', '    }\n', '\n', '    function recoverTokens(address token_) public auth {\n', '        ERC20 token = ERC20(token_);\n', '        token.transfer(beneficiary, token.balanceOf(this));\n', '    }\n', '\n', '\n', '    // PRIVATE\n', '\n', '    function contribute() private saleOpen requireWhitelist {\n', '        require(msg.value >= minContributionAmount);\n', '        require(maxTotalAmount >= add(totalContributedAmount, msg.value));\n', '\n', '        contributions[msg.sender] += msg.value;\n', '        totalContributedAmount += msg.value;\n', '        LogContribute(msg.sender, msg.value);\n', '    }\n', '}']