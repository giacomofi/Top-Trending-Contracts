['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-17\n', '*/\n', '\n', '//   _    _ _   _                __ _                            \n', '//  | |  (_) | | |              / _(_)                           \n', '//  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ \n', "//  | |/ / | __| __/ _ \\ '_ \\  |  _| | '_ \\ / _` | '_ \\ / __/ _ \\\n", '//  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/\n', '//  |_|\\_\\_|\\__|\\__\\___|_| |_(_)_| |_|_| |_|\\__,_|_| |_|\\___\\___|\n', '//\n', '//  KittenSwap v0.1\n', '//\n', '//  https://www.KittenSwap.org/\n', '//\n', 'pragma solidity ^0.6.12;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "!!add");\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "!!sub");\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "!!mul");\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "!!div");\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != 0x0 && codehash != accountHash);\n', '    }\n', '}\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '////////////////////////////////////////////////////////////////////////////////\n', '\n', 'contract KittenSwapV01 \n', '{\n', '    using SafeMath for uint256;\n', '    using SafeERC20 for IERC20;\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    address public govAddr;\n', '    address public devAddr;\n', '    \n', '    constructor () public {\n', '        govAddr = msg.sender;\n', '        devAddr = msg.sender;\n', '    }\n', '    \n', '    modifier govOnly() \n', '    {\n', '    \trequire(msg.sender == govAddr, "!gov");\n', '    \t_;\n', '    }\n', '    function govTransferAddr(address newAddr) external govOnly \n', '    {\n', '    \trequire(newAddr != address(0), "!addr");\n', '    \tgovAddr = newAddr;\n', '    }\n', '    \n', '    modifier devOnly() \n', '    {\n', '    \trequire(msg.sender == devAddr, "!dev");\n', '    \t_;\n', '    }\n', '    function devTransferAddr(address newAddr) external govOnly \n', '    {\n', '    \trequire(newAddr != address(0), "!addr");\n', '    \tdevAddr = newAddr;\n', '    }\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    mapping (address => mapping (address => uint)) public vault;\n', '    \n', '    event VAULT_DEPOSIT(address indexed user, address indexed token, uint amt);\n', '    event VAULT_WITHDRAW(address indexed user, address indexed token, uint amt);\n', '    \n', '    function vaultWithdraw(address token, uint amt) external \n', '    {\n', '        address payable user = msg.sender;\n', '\n', '        vault[user][token] = vault[user][token].sub(amt);\n', '        if (token == address(0)) {\n', '            user.transfer(amt);\n', '        } else {\n', '            IERC20(token).safeTransfer(user, amt);\n', '        }\n', '        emit VAULT_WITHDRAW(user, token, amt);\n', '    }\n', '    \n', '    function vaultDeposit(address token, uint amt) external payable\n', '    {\n', '        address user = msg.sender;\n', '\n', '        if (token == address(0)) {\n', '            vault[user][token] = vault[user][token].add(msg.value);\n', '        } else {\n', '            IERC20(token).safeTransferFrom(user, address(this), amt);\n', '            vault[user][token] = vault[user][token].add(amt);\n', '        }\n', '        emit VAULT_DEPOSIT(user, token, amt);\n', '    }    \n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    struct MARKET {\n', '        address token;        // fixed after creation\n', '        uint96 AMT_SCALE;     // fixed after creation\n', '        uint96 PRICE_SCALE;   // fixed after creation\n', '        uint16 DEVFEE_BP;     // in terms of basis points (1 bp = 0.01%)\n', '    }\n', '    MARKET[] public marketList;\n', '    \n', '    event MARKET_CREATE(address indexed token, uint96 $AMT_SCALE, uint96 $PRICE_SCALE, uint indexed id);\n', '    \n', '    function govCreateMarket(address $token, uint96 $AMT_SCALE, uint96 $PRICE_SCALE, uint16 $DEVFEE_BP) external govOnly \n', '    {\n', '        require ($AMT_SCALE > 0);\n', '        require ($PRICE_SCALE > 0);\n', '        require ($DEVFEE_BP <= 60);\n', '        \n', '        MARKET memory m;\n', '        m.token = $token;\n', '        m.AMT_SCALE = $AMT_SCALE;\n', '        m.PRICE_SCALE = $PRICE_SCALE;\n', '        m.DEVFEE_BP = $DEVFEE_BP;\n', '        \n', '        marketList.push(m);\n', '        \n', '        emit MARKET_CREATE($token, $AMT_SCALE, $PRICE_SCALE, marketList.length - 1);\n', '    }\n', '    \n', '    function govSetDevFee(uint $marketId, uint16 $DEVFEE_BP) external govOnly \n', '    {\n', '        require ($DEVFEE_BP <= 60);\n', '        marketList[$marketId].DEVFEE_BP = $DEVFEE_BP;\n', '    }\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    struct ORDER {\n', '        uint32 tokenAmtScaled;  // scaled by AMT_SCALE        SCALE 10^12 => 1 ~ 2^32-1 means 0.000001 ~ 4294.967295\n', '        uint24 priceLowScaled;  // scaled by PRICE_SCALE      SCALE 10^4 => 1 ~ 2^24-1 means 0.0001 ~ 1677.7215\n', '        uint24 priceHighScaled; // scaled by PRICE_SCALE      SCALE 10^4 => 1 ~ 2^24-1 means 0.0001 ~ 1677.7215\n', '        uint160 userMaker;\n', '    }\n', '    mapping (uint => ORDER[]) public orderList; // div 2 = market, mod 2 = 0 sell, 1 buy\n', '    \n', '    uint constant UINT32_MAX = 2**32 - 1;\n', '    \n', '    event ORDER_CREATE(address indexed userMaker, uint indexed marketIsBuy, uint orderInfo, uint indexed orderId);\n', '    event ORDER_MODIFY(address indexed userMaker, uint indexed marketIsBuy, uint newOrderInfo, uint indexed orderId);\n', '    event ORDER_TRADE(address indexed userTaker, address userMaker, uint indexed marketIsBuy, uint fillOrderInfo, uint indexed orderId);\n', '\n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    function marketCount() external view returns (uint)\n', '    {\n', '        return marketList.length;\n', '    }\n', '    \n', '    function orderCount(uint $marketIsBuy) external view returns (uint)\n', '    {\n', '        return orderList[$marketIsBuy].length;\n', '    }\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    function orderCreate(uint $marketIsBuy, uint32 $tokenAmtScaled, uint24 $priceLowScaled, uint24 $priceHighScaled) external payable \n', '    {\n', '        require($priceLowScaled > 0, "!priceLow");\n', '        require($priceHighScaled > 0, "!priceHigh");\n', '        require($priceHighScaled >= $priceLowScaled, "!priceRange");\n', '\n', '        uint isMakerBuy = $marketIsBuy % 2;\n', '        MARKET memory m = marketList[$marketIsBuy / 2];\n', '        require(m.token != address(0), "!market");\n', '        \n', '        //------------------------------------------------------------------------------\n', '\n', '        address userMaker = msg.sender;\n', '            \n', '        if (isMakerBuy > 0) // buy token -> deposit ETH\n', '        {\n', '            uint ethAmt = uint($tokenAmtScaled) * uint(m.AMT_SCALE) * (uint($priceLowScaled) + uint($priceHighScaled)) / uint(m.PRICE_SCALE * 2);\n', "            require(msg.value == ethAmt, '!eth');\n", '        }\n', '        else // sell token -> deposit token\n', '        {\n', '            IERC20 token = IERC20(m.token);\n', '            if ($tokenAmtScaled > 0)\n', '                token.safeTransferFrom(userMaker, address(this), uint($tokenAmtScaled) * uint(m.AMT_SCALE));\n', "            require(msg.value == 0, '!eth');\n", '        }\n', '        \n', '        //------------------------------------------------------------------------------\n', '        \n', '        ORDER memory o;\n', '        o.userMaker = uint160(userMaker);\n', '        o.tokenAmtScaled = $tokenAmtScaled;\n', '        o.priceLowScaled = $priceLowScaled;\n', '        o.priceHighScaled = $priceHighScaled;\n', '        \n', '        //------------------------------------------------------------------------------\n', '\n', '        ORDER[] storage oList = orderList[$marketIsBuy];\n', '        oList.push(o);\n', '        \n', '        uint orderId = oList.length - 1;\n', '        uint orderInfo = $tokenAmtScaled | ($priceLowScaled<<32) | ($priceHighScaled<<(32+24));\n', '\n', '        emit ORDER_CREATE(userMaker, $marketIsBuy, orderInfo, orderId);\n', '    }\n', '\n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    function orderModify(uint $marketIsBuy, uint32 newTokenAmtScaled, uint24 newPriceLowScaled, uint24 newPriceHighScaled, uint orderID) external payable \n', '    {\n', '        require(newPriceLowScaled > 0, "!priceLow");\n', '        require(newPriceHighScaled > 0, "!priceHigh");\n', '        require(newPriceHighScaled >= newPriceLowScaled, "!priceRange");\n', '        \n', '        address payable userMaker = msg.sender;\n', '        ORDER storage o = orderList[$marketIsBuy][orderID];\n', '        require (uint160(userMaker) == o.userMaker, "!user");\n', '\n', '        uint isMakerBuy = $marketIsBuy % 2;\n', '        MARKET memory m = marketList[$marketIsBuy / 2];\n', '        \n', '        //------------------------------------------------------------------------------\n', '\n', '        if (isMakerBuy > 0) // old order: maker buy token -> modify ETH amt\n', '        {\n', '            uint oldEthAmt = uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) * (uint(o.priceLowScaled) + uint(o.priceHighScaled)) / uint(m.PRICE_SCALE * 2);\n', '            uint newEthAmt = uint(newTokenAmtScaled) * uint(m.AMT_SCALE) * (uint(newPriceLowScaled) + uint(newPriceHighScaled)) / uint(m.PRICE_SCALE * 2);\n', '\n', '            uint extraEthAmt = (msg.value).add(oldEthAmt).sub(newEthAmt); // throw if not enough\n', '            \n', '            if (extraEthAmt > 0)\n', '                userMaker.transfer(extraEthAmt); // return extra ETH to maker\n', '        }\n', '        else // old order: maker sell token -> modify token amt\n', '        {\n', '            uint oldTokenAmt = uint(o.tokenAmtScaled) * uint(m.AMT_SCALE);\n', '            uint newTokenAmt = uint(newTokenAmtScaled) * uint(m.AMT_SCALE);\n', '\n', '            IERC20 token = IERC20(m.token);\n', '            if (newTokenAmt > oldTokenAmt) {\n', '                token.safeTransferFrom(userMaker, address(this), newTokenAmt - oldTokenAmt);\n', '            }\n', '            else if (newTokenAmt < oldTokenAmt) {\n', '                token.safeTransfer(userMaker, oldTokenAmt - newTokenAmt); // return extra token to maker\n', '            }\n', "            require(msg.value == 0, '!eth');            \n", '        }\n', '        \n', '        //------------------------------------------------------------------------------\n', '        \n', '        if (o.tokenAmtScaled != newTokenAmtScaled)\n', '            o.tokenAmtScaled = newTokenAmtScaled;\n', '        if (o.priceLowScaled != newPriceLowScaled)\n', '            o.priceLowScaled = newPriceLowScaled;\n', '        if (o.priceHighScaled != newPriceHighScaled)\n', '            o.priceHighScaled = newPriceHighScaled;\n', '\n', '        uint orderInfo = newTokenAmtScaled | (newPriceLowScaled<<32) | (newPriceHighScaled<<(32+24));\n', '\n', '        emit ORDER_MODIFY(userMaker, $marketIsBuy, orderInfo, orderID);\n', '    }\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    \n', '    \n', '    function _fill_WLO(ORDER storage o, MARKET memory m, uint isMakerBuy, uint32 $tokenAmtScaled, uint24 fillPriceWorstScaled) internal returns (uint fillTokenAmtScaled, uint fillEthAmt)\n', '    {\n', '        uint allSlots = uint(1) + uint(o.priceHighScaled) - uint(o.priceLowScaled);\n', '        uint fullFillSlots = allSlots * ($tokenAmtScaled) / uint(o.tokenAmtScaled);\n', '        if (fullFillSlots > allSlots) {\n', '            fullFillSlots = allSlots;\n', '        }\n', '        \n', '        if (isMakerBuy > 0) // maker buy token -> taker sell token\n', '        {\n', "            require (fillPriceWorstScaled <= o.priceHighScaled, '!price');\n", '            uint fillPriceEndScaled = uint(o.priceHighScaled).sub(fullFillSlots);\n', '            if ((uint(fillPriceWorstScaled) * 2) > (o.priceHighScaled))\n', '            {\n', '                uint _ppp = (uint(fillPriceWorstScaled) * 2) - (o.priceHighScaled);\n', '                if (fillPriceEndScaled < _ppp)\n', '                    fillPriceEndScaled = _ppp;\n', '            }\n', "            require (fillPriceEndScaled <= o.priceHighScaled, '!price');\n", '            \n', '            //------------------------------------------------------------------------------\n', '            \n', '            if (($tokenAmtScaled >= o.tokenAmtScaled) && (fillPriceEndScaled <= o.priceLowScaled)) // full fill\n', '            {\n', '                fillTokenAmtScaled = o.tokenAmtScaled;\n', '                fillEthAmt = uint(fillTokenAmtScaled) * uint(m.AMT_SCALE) * (uint(o.priceLowScaled) + uint(o.priceHighScaled)) / uint(m.PRICE_SCALE * 2);\n', '\n', '                o.tokenAmtScaled = 0;\n', '\n', '                return (fillTokenAmtScaled, fillEthAmt);\n', '            }\n', '            \n', '            //------------------------------------------------------------------------------\n', '            \n', '            {\n', '                uint fillTokenAmtFirst = 0; // full fill @ [fillPriceEndScaled+1, priceHighScaled]\n', '                {\n', '                    uint firstFillSlots = uint(o.priceHighScaled) - uint(fillPriceEndScaled);\n', '                    fillTokenAmtFirst = firstFillSlots * uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) / allSlots;\n', '                }\n', '                fillEthAmt = fillTokenAmtFirst * (uint(o.priceHighScaled) + uint(fillPriceEndScaled) + 1) / uint(m.PRICE_SCALE * 2);\n', '                \n', '                uint fillTokenAmtSecond = (uint($tokenAmtScaled) * uint(m.AMT_SCALE)).sub(fillTokenAmtFirst); // partial fill @ fillPriceEndScaled\n', '                {\n', '                    uint amtPerSlot = uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) / allSlots;\n', '                    if (fillTokenAmtSecond > amtPerSlot) {\n', '                        fillTokenAmtSecond = amtPerSlot;\n', '                    }\n', '                }\n', '                \n', '                fillTokenAmtScaled = (fillTokenAmtFirst + fillTokenAmtSecond) / uint(m.AMT_SCALE);\n', '                \n', '                fillTokenAmtSecond = (fillTokenAmtScaled * uint(m.AMT_SCALE)).sub(fillTokenAmtFirst);\n', '                fillEthAmt = fillEthAmt.add(fillTokenAmtSecond * fillPriceEndScaled / uint(m.PRICE_SCALE));\n', '            }\n', '            \n', '            //------------------------------------------------------------------------------\n', '            \n', '            uint newPriceHighScaled =\n', '                (\n', '                    ( uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) * (uint(o.priceLowScaled) + uint(o.priceHighScaled)) )\n', '                    .sub\n', '                    ( fillEthAmt * uint(m.PRICE_SCALE * 2) )\n', '                )\n', '                /\n', '                ( (uint(o.tokenAmtScaled).sub(fillTokenAmtScaled)) * uint(m.AMT_SCALE) )\n', '            ;\n', '            newPriceHighScaled = newPriceHighScaled.sub(o.priceLowScaled);\n', '            \n', '            require (newPriceHighScaled >= o.priceLowScaled, "!badFinalRange"); // shall never happen\n', '            \n', '            o.priceHighScaled = uint24(newPriceHighScaled);        \n', '            \n', '            o.tokenAmtScaled = uint32(uint(o.tokenAmtScaled).sub(fillTokenAmtScaled));\n', '        }\n', '        //------------------------------------------------------------------------------\n', '        else // maker sell token -> taker buy token\n', '        {\n', "            require (fillPriceWorstScaled >= o.priceLowScaled, '!price');\n", '            uint fillPriceEndScaled = uint(o.priceLowScaled).add(fullFillSlots);\n', '            {\n', '                uint _ppp = (uint(fillPriceWorstScaled) * 2).sub(o.priceLowScaled);\n', '                if (fillPriceEndScaled > _ppp)\n', '                    fillPriceEndScaled = _ppp;\n', '            }\n', "            require (fillPriceEndScaled >= o.priceLowScaled, '!price');\n", '            \n', '            //------------------------------------------------------------------------------\n', '            \n', '            if (($tokenAmtScaled >= o.tokenAmtScaled) && (fillPriceEndScaled >= o.priceHighScaled)) // full fill\n', '            {\n', '                fillTokenAmtScaled = o.tokenAmtScaled;\n', '                fillEthAmt = uint(fillTokenAmtScaled) * uint(m.AMT_SCALE) * (uint(o.priceLowScaled) + uint(o.priceHighScaled)) / uint(m.PRICE_SCALE * 2);\n', '\n', '                o.tokenAmtScaled = 0;\n', '\n', '                return (fillTokenAmtScaled, fillEthAmt);\n', '            }\n', '            \n', '            //------------------------------------------------------------------------------\n', '\n', '            {\n', '                uint fillTokenAmtFirst = 0; // full fill @ [priceLowScaled, fillPriceEndScaled-1]\n', '                {\n', '                    uint firstFillSlots = uint(fillPriceEndScaled) - uint(o.priceLowScaled);\n', '                    fillTokenAmtFirst = firstFillSlots * uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) / allSlots;\n', '                }\n', '                fillEthAmt = fillTokenAmtFirst * (uint(o.priceLowScaled) + uint(fillPriceEndScaled) - 1) / uint(m.PRICE_SCALE * 2);\n', '                \n', '                uint fillTokenAmtSecond = (uint($tokenAmtScaled) * uint(m.AMT_SCALE)).sub(fillTokenAmtFirst); // partial fill @ fillPriceEndScaled\n', '                {\n', '                    uint amtPerSlot = uint(o.tokenAmtScaled) * uint(m.AMT_SCALE) / allSlots;\n', '                    if (fillTokenAmtSecond > amtPerSlot) {\n', '                        fillTokenAmtSecond = amtPerSlot;\n', '                    }\n', '                }\n', '                \n', '                fillTokenAmtScaled = (fillTokenAmtFirst + fillTokenAmtSecond) / uint(m.AMT_SCALE);\n', '                \n', '                fillTokenAmtSecond = (fillTokenAmtScaled * uint(m.AMT_SCALE)).sub(fillTokenAmtFirst);\n', '                fillEthAmt = fillEthAmt.add(fillTokenAmtSecond * fillPriceEndScaled / uint(m.PRICE_SCALE));\n', '            }\n', '            \n', '            //------------------------------------------------------------------------------\n', '            \n', '            o.tokenAmtScaled = uint32(uint(o.tokenAmtScaled).sub(fillTokenAmtScaled));\n', '            o.priceLowScaled = uint24(fillPriceEndScaled);\n', '        }\n', '    }\n', '    \n', '    ////////////////////////////////////////////////////////////////////////////////\n', '    \n', '    function orderTrade(uint $marketIsBuy, uint32 $tokenAmtScaled, uint24 fillPriceWorstScaled, uint orderID) external payable \n', '    {\n', '        ORDER storage o = orderList[$marketIsBuy][orderID];\n', "        require ($tokenAmtScaled > 0, '!amt');\n", "        require (o.tokenAmtScaled > 0, '!amt');\n", '\n', '        address payable userTaker = msg.sender;\n', '        address payable userMaker = payable(o.userMaker);\n', '\n', '        uint isMakerBuy = $marketIsBuy % 2;\n', '        MARKET memory m = marketList[$marketIsBuy / 2];\n', '        IERC20 token = IERC20(m.token);\n', '\n', '        uint fillTokenAmtScaled = 0;\n', '        uint fillEthAmt = 0;\n', '        \n', '        //------------------------------------------------------------------------------\n', '\n', '        if (o.priceLowScaled == o.priceHighScaled) // simple limit order\n', '        {\n', '            uint fillPriceScaled = o.priceLowScaled;\n', '            \n', '            if (isMakerBuy > 0) { // maker buy token -> taker sell token\n', '                require (fillPriceScaled >= fillPriceWorstScaled, "!price"); // sell at higher price\n', '            }\n', '            else { // maker sell token -> taker buy token\n', '                require (fillPriceScaled <= fillPriceWorstScaled, "!price"); // buy at lower price\n', '            }\n', '            \n', '            //------------------------------------------------------------------------------\n', '\n', '            fillTokenAmtScaled = $tokenAmtScaled;\n', '            if (fillTokenAmtScaled > o.tokenAmtScaled)\n', '                fillTokenAmtScaled = o.tokenAmtScaled;\n', '\n', '            fillEthAmt = fillTokenAmtScaled * uint(m.AMT_SCALE) * (fillPriceScaled) / uint(m.PRICE_SCALE);\n', '\n', '            o.tokenAmtScaled = uint32(uint(o.tokenAmtScaled).sub(fillTokenAmtScaled));\n', '        }\n', '        //------------------------------------------------------------------------------\n', '        else // Wide Limit Order\n', '        {\n', "            require (o.priceHighScaled > o.priceLowScaled, '!badOrder');\n", '            \n', '            (fillTokenAmtScaled, fillEthAmt) = _fill_WLO(o, m, isMakerBuy, $tokenAmtScaled, fillPriceWorstScaled); // will modify order\n', '        }\n', '        \n', '        //------------------------------------------------------------------------------\n', '        \n', '        require(fillTokenAmtScaled > 0, "!fillTokenAmtScaled");\n', '        require(fillEthAmt > 0, "!fillEthAmt");\n', '        \n', '        uint fillTokenAmt = fillTokenAmtScaled * uint(m.AMT_SCALE);\n', '        \n', '        if (isMakerBuy > 0) // maker buy token -> taker sell token\n', '        {\n', '            token.safeTransferFrom(userTaker, userMaker, fillTokenAmt); // send token to maker (from taker)\n', '\n', '            uint devFee = fillEthAmt * uint(m.DEVFEE_BP) / (10000);\n', '            vault[devAddr][address(0)] = vault[devAddr][address(0)].add(devFee);\n', '\n', '            userTaker.transfer(fillEthAmt.sub(devFee)); // send eth to taker\n', "            require(msg.value == 0, '!eth');\n", '        }\n', '        else // maker sell token -> taker buy token\n', '        {\n', "            require(msg.value >= fillEthAmt, '!eth');\n", '            \n', '            token.safeTransfer(userTaker, fillTokenAmt); // send token to taker\n', '\n', '            uint devFee = fillEthAmt * uint(m.DEVFEE_BP) / (10000);\n', '            vault[devAddr][address(0)] = vault[devAddr][address(0)].add(devFee);\n', '\n', '            userMaker.transfer(fillEthAmt.sub(devFee)); // send eth to maker\n', '            \n', '            if (msg.value > fillEthAmt) {\n', '                userTaker.transfer(msg.value - fillEthAmt); // return extra eth to taker\n', '            }\n', '        }\n', '\n', '        //------------------------------------------------------------------------------\n', '\n', '        uint orderInfo = fillTokenAmtScaled | fillEthAmt<<32;\n', '\n', '        emit ORDER_TRADE(userTaker, userMaker, $marketIsBuy, orderInfo, orderID);    \n', '    }\n', '}']