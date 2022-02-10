['// hevm: flattened sources of src/sushi-farm.sol\n', 'pragma solidity >0.4.13 >=0.4.23 >=0.5.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;\n', '\n', '////// lib/ds-auth/src/auth.sol\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity >=0.4.23; */\n', '\n', 'interface DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) external view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(address(authority));\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, address(this), sig);\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/ds-math/src/math.sol\n', '/// math.sol -- mixin for inline numerical wizardry\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity >0.4.13; */\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x, "ds-math-add-overflow");\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x, "ds-math-sub-underflow");\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    //rounds to zero if x*y < WAD / 2\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    //rounds to zero if x*y < WAD / 2\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    //rounds to zero if x*y < WAD / 2\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    //rounds to zero if x*y < RAY / 2\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '////// lib/ds-token/src/token.sol\n', '/// token.sol -- ERC20 implementation with minting and burning\n', '\n', '// Copyright (C) 2015, 2016, 2017  DappHub, LLC\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '/* pragma solidity >=0.4.23; */\n', '\n', '/* import "ds-math/math.sol"; */\n', '/* import "ds-auth/auth.sol"; */\n', '\n', '\n', 'contract DSToken is DSMath, DSAuth {\n', '    bool                                              public  stopped;\n', '    uint256                                           public  totalSupply;\n', '    mapping (address => uint256)                      public  balanceOf;\n', '    mapping (address => mapping (address => uint256)) public  allowance;\n', '    bytes32                                           public  symbol;\n', '    uint256                                           public  decimals = 18; // standard token precision. override to customize\n', '    bytes32                                           public  name = "";     // Optional token name\n', '\n', '    constructor(bytes32 symbol_) public {\n', '        symbol = symbol_;\n', '    }\n', '\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '    event Mint(address indexed guy, uint wad);\n', '    event Burn(address indexed guy, uint wad);\n', '    event Stop();\n', '    event Start();\n', '\n', '    modifier stoppable {\n', '        require(!stopped, "ds-stop-is-stopped");\n', '        _;\n', '    }\n', '\n', '    function approve(address guy) external returns (bool) {\n', '        return approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        allowance[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address dst, uint wad) external returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        stoppable\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {\n', '            require(allowance[src][msg.sender] >= wad, "ds-token-insufficient-approval");\n', '            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);\n', '        }\n', '\n', '        require(balanceOf[src] >= wad, "ds-token-insufficient-balance");\n', '        balanceOf[src] = sub(balanceOf[src], wad);\n', '        balanceOf[dst] = add(balanceOf[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function push(address dst, uint wad) external {\n', '        transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function pull(address src, uint wad) external {\n', '        transferFrom(src, msg.sender, wad);\n', '    }\n', '\n', '    function move(address src, address dst, uint wad) external {\n', '        transferFrom(src, dst, wad);\n', '    }\n', '\n', '\n', '    function mint(uint wad) external {\n', '        mint(msg.sender, wad);\n', '    }\n', '\n', '    function burn(uint wad) external {\n', '        burn(msg.sender, wad);\n', '    }\n', '\n', '    function mint(address guy, uint wad) public auth stoppable {\n', '        balanceOf[guy] = add(balanceOf[guy], wad);\n', '        totalSupply = add(totalSupply, wad);\n', '        emit Mint(guy, wad);\n', '    }\n', '\n', '    function burn(address guy, uint wad) public auth stoppable {\n', '        if (guy != msg.sender && allowance[guy][msg.sender] != uint(-1)) {\n', '            require(allowance[guy][msg.sender] >= wad, "ds-token-insufficient-approval");\n', '            allowance[guy][msg.sender] = sub(allowance[guy][msg.sender], wad);\n', '        }\n', '\n', '        require(balanceOf[guy] >= wad, "ds-token-insufficient-balance");\n', '        balanceOf[guy] = sub(balanceOf[guy], wad);\n', '        totalSupply = sub(totalSupply, wad);\n', '        emit Burn(guy, wad);\n', '    }\n', '\n', '    function stop() public auth {\n', '        stopped = true;\n', '        emit Stop();\n', '    }\n', '\n', '    function start() public auth {\n', '        stopped = false;\n', '        emit Start();\n', '    }\n', '\n', '    function setName(bytes32 name_) external auth {\n', '        name = name_;\n', '    }\n', '}\n', '\n', '////// src/constants.sol\n', '/* pragma solidity ^0.6.7; */\n', '\n', '\n', 'library Constants {\n', '    // Tokens\n', '    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address constant SUSHI = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;\n', '    address constant UNIV2_SUSHI_ETH = 0xCE84867c3c02B05dc570d0135103d3fB9CC19433;\n', '\n', '    // Uniswap\n', '    address constant UNIV2_ROUTER2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '\n', '    // Sushiswap\n', '    address constant MASTERCHEF = 0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd;\n', '}\n', '////// src/interfaces/masterchef.sol\n', '// SPDX-License-Identifier: MIT\n', '/* pragma solidity ^0.6.2; */\n', '\n', 'interface Masterchef {\n', '    function deposit(uint256 _pid, uint256 _amount) external;\n', '\n', '    function withdraw(uint256 _pid, uint256 _amount) external;\n', '\n', '    function userInfo(uint256, address)\n', '        external\n', '        view\n', '        returns (uint256 amount, uint256 rewardDebt);\n', '}\n', '\n', '////// src/interfaces/uniswap.sol\n', '// SPDX-License-Identifier: MIT\n', '/* pragma solidity ^0.6.2; */\n', '\n', 'interface UniswapRouterV2 {\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        returns (\n', '            uint256 amountA,\n', '            uint256 amountB,\n', '            uint256 liquidity\n', '        );\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] calldata path)\n', '        external\n', '        view\n', '        returns (uint256[] memory amounts);\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable returns (uint256[] memory amounts);\n', '}\n', '\n', 'interface UniswapPair {\n', '    function getReserves()\n', '        external\n', '        view\n', '        returns (\n', '            uint112 reserve0,\n', '            uint112 reserve1,\n', '            uint32 blockTimestamp\n', '        );\n', '}\n', '\n', '////// src/sushi-farm.sol\n', '/* pragma solidity ^0.6.7; */\n', '\n', '/* import "ds-math/math.sol"; */\n', '/* import "ds-token/token.sol"; */\n', '\n', '/* import "./interfaces/masterchef.sol"; */\n', '/* import "./interfaces/uniswap.sol"; */\n', '\n', '/* import "./constants.sol"; */\n', '\n', '// Sushi Farm in SushiSwap\n', '// Used to farm sushi. i.e. Deposit into this pool if you want to LONG sushi.\n', '\n', '// Based off https://github.com/iearn-finance/vaults/blob/master/contracts/yVault.sol\n', 'contract SushiFarm is DSMath {\n', '    // Tokens\n', '    DSToken public sushi = DSToken(Constants.SUSHI);\n', '    DSToken public univ2SushiEth = DSToken(Constants.UNIV2_SUSHI_ETH);\n', '    DSToken public weth = DSToken(Constants.WETH);\n', '    DSToken public gSushi;\n', '\n', '    // Uniswap Router and Pair\n', '    UniswapRouterV2 public univ2 = UniswapRouterV2(Constants.UNIV2_ROUTER2);\n', '    UniswapPair public univ2Pair = UniswapPair(address(univ2SushiEth));\n', '\n', '    // Masterchef Contract\n', '    Masterchef public masterchef = Masterchef(Constants.MASTERCHEF);\n', '    uint256 public univ2SushiEthPoolId = 12;\n', '\n', '    // 5% reward for anyone who calls HARVEST\n', '    uint256 public callerRewards = 5 ether / 100;\n', '\n', '    // Last harvest\n', '    uint256 public lastHarvest = 0;\n', '\n', '    constructor() public {\n', '        gSushi = new DSToken("gSushi");\n', '        gSushi.setName("Grazing Sushi");\n', '    }\n', '\n', '    // **** Harvest profits ****\n', '\n', '    function harvest() public {\n', '        // Only callable every hour or so\n', '        if (lastHarvest > 0) {\n', '            require(lastHarvest + 1 hours <= block.timestamp, "!harvest-time");\n', '        }\n', '        lastHarvest = block.timestamp;\n', '\n', '        // Withdraw sushi\n', '        masterchef.withdraw(univ2SushiEthPoolId, 0);\n', '\n', '        uint256 amount = sushi.balanceOf(address(this));\n', '        uint256 reward = div(mul(amount, callerRewards), 100 ether);\n', '\n', '        // Sends 5% fee to caller\n', '        sushi.transfer(msg.sender, reward);\n', '\n', '        // Remove amount from rewards\n', '        amount = sub(amount, reward);\n', '\n', '        // Add to UniV2 pool\n', '        _sushiToUniV2SushiEth(amount);\n', '\n', '        // Deposit into masterchef contract\n', '        uint256 balance = univ2SushiEth.balanceOf(address(this));\n', '        univ2SushiEth.approve(address(masterchef), balance);\n', '        masterchef.deposit(univ2SushiEthPoolId, balance);\n', '    }\n', '\n', '    // **** Withdraw / Deposit functions ****\n', '\n', '    function withdrawAll() external {\n', '        withdraw(gSushi.balanceOf(msg.sender));\n', '    }\n', '\n', '    function withdraw(uint256 _shares) public {\n', '        uint256 univ2Balance = univ2SushiEthBalance();\n', '\n', '        uint256 amount = div(mul(_shares, univ2Balance), gSushi.totalSupply());\n', '        gSushi.burn(msg.sender, _shares);\n', '\n', '        // Withdraw from Masterchef contract\n', '        masterchef.withdraw(univ2SushiEthPoolId, amount);\n', '\n', '        // Retrive shares from Uniswap pool and converts to SUSHI\n', '        uint256 _before = sushi.balanceOf(address(this));\n', '        _uniV2SushiEthToSushi(amount);\n', '        uint256 _after = sushi.balanceOf(address(this));\n', '\n', '        // Transfer back SUSHI difference\n', '        sushi.transfer(msg.sender, sub(_after, _before));\n', '    }\n', '\n', '    function depositAll() external {\n', '        deposit(sushi.balanceOf(msg.sender));\n', '    }\n', '\n', '    function deposit(uint256 _amount) public {\n', '        sushi.transferFrom(msg.sender, address(this), _amount);\n', '\n', '        uint256 _pool = univ2SushiEthBalance();\n', '        uint256 _before = univ2SushiEth.balanceOf(address(this));\n', '        _sushiToUniV2SushiEth(_amount);\n', '        uint256 _after = univ2SushiEth.balanceOf(address(this));\n', '\n', '        _amount = sub(_after, _before); // Additional check for deflationary tokens\n', '\n', '        uint256 shares = 0;\n', '        if (gSushi.totalSupply() == 0) {\n', '            shares = _amount;\n', '        } else {\n', '            shares = div(mul(_amount, gSushi.totalSupply()), _pool);\n', '        }\n', '\n', '        // Deposit into Masterchef contract to get rewards\n', '        univ2SushiEth.approve(address(masterchef), _amount);\n', '        masterchef.deposit(univ2SushiEthPoolId, _amount);\n', '\n', '        gSushi.mint(msg.sender, shares);\n', '    }\n', '\n', '    // Takes <x> amount of SUSHI\n', '    // Converts half of it into ETH,\n', '    // Supplies them into SUSHI/ETH pool\n', '    function _sushiToUniV2SushiEth(uint256 _amount) internal {\n', '        uint256 half = div(_amount, 2);\n', '\n', '        // Convert half of the sushi to ETH\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(sushi);\n', '        path[1] = address(weth);\n', '        sushi.approve(address(univ2), half);\n', '        univ2.swapExactTokensForTokens(half, 0, path, address(this), now + 60);\n', '\n', '        // Supply liquidity\n', '        uint256 wethBal = weth.balanceOf(address(this));\n', '        uint256 sushiBal = sushi.balanceOf(address(this));\n', '        sushi.approve(address(univ2), sushiBal);\n', '        weth.approve(address(univ2), wethBal);\n', '        univ2.addLiquidity(\n', '            address(sushi),\n', '            address(weth),\n', '            sushiBal,\n', '            wethBal,\n', '            0,\n', '            0,\n', '            address(this),\n', '            now + 60\n', '        );\n', '    }\n', '\n', '    // Takes <x> amount of gSushi\n', '    // And removes liquidity from SUSHI/ETH pool\n', '    // Converts the ETH into Sushi\n', '    function _uniV2SushiEthToSushi(uint256 _amount) internal {\n', '        // Remove liquidity\n', '        require(\n', '            univ2SushiEth.balanceOf(address(this)) >= _amount,\n', '            "not-enough-liquidity"\n', '        );\n', '        univ2SushiEth.approve(address(univ2), _amount);\n', '        univ2.removeLiquidity(\n', '            address(sushi),\n', '            address(weth),\n', '            _amount,\n', '            0,\n', '            0,\n', '            address(this),\n', '            now + 60\n', '        );\n', '\n', '        // Convert ETH to SUSHI\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(weth);\n', '        path[1] = address(sushi);\n', '        uint256 wethBal = weth.balanceOf(address(this));\n', '        weth.approve(address(univ2), wethBal);\n', '        univ2.swapExactTokensForTokens(\n', '            wethBal,\n', '            0,\n', '            path,\n', '            address(this),\n', '            now + 60\n', '        );\n', '    }\n', '\n', '    // 1 gSUSHI = <x> SUSHI\n', '    function getGSushiOverSushiRatio() public view returns (uint256) {\n', '        // How much UniV2 do we have\n', '        uint256 uniV2Balance = univ2SushiEthBalance();\n', '\n', '        if (uniV2Balance == 0) {\n', '            return 0;\n', '        }\n', '\n', '        // How many SUSHI and ETH can we get for this?\n', '        (uint112 _poolSushiReserve, uint112 _poolWETHReserve, ) = univ2Pair\n', '            .getReserves(); // SUSHI and WETH in pool\n', '        uint256 uniV2liquidity = univ2SushiEth.totalSupply(); // Univ2 total supply\n', '        uint256 uniV2percentage = div(mul(uniV2Balance, 1e18), uniV2liquidity); // How much we own %-wise\n', '\n', '        uint256 removableSushi = uint256(\n', '            div(mul(_poolSushiReserve, uniV2percentage), 1e18)\n', '        );\n', '        uint256 removableWeth = uint256(\n', '            div(mul(_poolWETHReserve, uniV2percentage), 1e18)\n', '        );\n', '\n', '        // How many SUSHI can we get for the ETH?\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(weth);\n', '        path[1] = address(sushi);\n', '        uint256[] memory outs = univ2.getAmountsOut(removableWeth, path);\n', '\n', '        // Get RATIO\n', '        return div(mul(add(outs[1], removableSushi), 1e18), gSushi.totalSupply());\n', '    }\n', '\n', '    function univ2SushiEthBalance() public view returns (uint256) {\n', '        (uint256 univ2Balance, ) = masterchef.userInfo(\n', '            univ2SushiEthPoolId,\n', '            address(this)\n', '        );\n', '\n', '        return univ2Balance;\n', '    }\n', '\n', '    // **** Internal functions ****\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "division by zero");\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}']