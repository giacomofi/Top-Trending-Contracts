['// SPDX-License-Identifier: J-J-J-JENGA!!!\n', 'pragma solidity ^0.7.4;\n', '\n', 'import "./Owned.sol";\n', 'import "./TokensRecoverable.sol";\n', 'import "./RootKit.sol";\n', 'import "./IERC31337.sol";\n', 'import "./IUniswapV2Router02.sol";\n', 'import "./IWETH.sol";\n', 'import "./IUniswapV2Pair.sol";\n', 'import "./IERC20.sol";\n', 'import "./RootKitTransferGate.sol";\n', 'import "./UniswapV2Library.sol";\n', 'import "./KETH.sol";\n', 'import "./SafeMath.sol";\n', 'import "./IPonzoMaBobberV696969.sol";\n', 'import "./IERC31337.sol";\n', 'import "./IFloorCalculator.sol";\n', '\n', '\n', 'contract PonzoMaBobberV696969 is TokensRecoverable, IPonzoMaBobberV696969\n', '\n', '    /*\n', '        Ponzo-Ma-BobberV69.sol\n', '        Status: Fully functional Infinity Edition with kETH swapper\n', '        Calibration: Pumping Rootkit\n', '        \n', '        The Ponzo-Ma-Bobber is a contract with access to critical system control\n', '        functions and liquidity tokens for ROOT. It uses kETH and the ERC-31337 \n', '        sweeper functionality to make upwards market manipulation less tiresome.\n', '\n', '        Created by @ProfessorPonzo\n', '    */\n', '\n', '{\n', '    using SafeMath for uint256;\n', '    IUniswapV2Router02 immutable uniswapV2Router;\n', '    IUniswapV2Factory immutable uniswapV2Factory;\n', '    RootKit immutable rootKit;\n', '    IWETH immutable weth;\n', '    KETH keth;\n', '    IERC20 IKETH;\n', '    IERC20 rootKeth;\n', '    IERC20 rootWeth;\n', '    IFloorCalculator calculator;\n', '    RootKitTransferGate gate;\n', '    mapping (address => bool) public infinitePumpers;\n', '\n', '    constructor(IUniswapV2Router02 _uniswapV2Router, IWETH _weth, RootKit _rootKit, IFloorCalculator _calculator, RootKitTransferGate _gate)\n', '    {\n', '        uniswapV2Router = _uniswapV2Router;\n', '        rootKit = _rootKit;\n', '        calculator = _calculator;\n', '        IUniswapV2Factory _uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());\n', '        uniswapV2Factory = _uniswapV2Factory;\n', '        weth = _weth;       \n', '        gate = _gate;\n', '\n', '        _weth.approve(address(_uniswapV2Router), uint256(-1));\n', '        _rootKit.approve(address(_uniswapV2Router), uint256(-1));\n', '        rootWeth = IERC20(_uniswapV2Factory.getPair(address(_weth), address(_rootKit)));\n', '        rootWeth.approve(address(_uniswapV2Router), uint256(-1));\n', '\n', '    }\n', '\n', '    function updateKethLOL(KETH _keth) public ownerOnly(){\n', '        keth = _keth;\n', '        weth.approve(address(_keth), uint256(-1));\n', '        _keth.approve(address(uniswapV2Router), uint256(-1));\n', '        rootKeth = IERC20(uniswapV2Factory.getPair(address(keth), address(rootKit)));\n', '        rootKeth.approve(address(uniswapV2Router), uint256(-1));\n', '    }\n', '        // The Pump Button is really fun, cant keep it all to myself\n', '    function setInfinitePumper(address pumper, bool infinite) public ownerOnly() {\n', '        infinitePumpers[pumper] = infinite;\n', '    }\n', '        // Removes liquidity and buys from either pool, ignores all Root \n', '    function pumpItPonzo (uint256 PUMPIT, address token) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        gate.setUnrestricted(true);\n', '        PUMPIT = removeLiq(token, PUMPIT);\n', '        buyRoot(token, PUMPIT);\n', '        gate.setUnrestricted(false);\n', '    }\n', '        // Sweeps the wETH under the floor to this address\n', '    function sweepTheFloor() public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        keth.sweepFloor(address(this));\n', '    }\n', '        // Move liquidity from kETH --->> wETH\n', '    function zapKethToWeth(uint256 liquidity) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        gate.setUnrestricted(true);\n', '        liquidity = removeLiq(address(keth), liquidity);\n', '        keth.withdrawTokens(liquidity);\n', '        addLiq(address(weth), liquidity);\n', '        gate.setUnrestricted(false);\n', '    }\n', '        // Move liquidity from wETH --->> kETH\n', '    function zapWethToKeth(uint256 liquidity) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        gate.setUnrestricted(true);\n', '        liquidity = removeLiq(address(weth), liquidity);\n', '        keth.depositTokens(liquidity);\n', '        addLiq(address(keth), liquidity);\n', '        gate.setUnrestricted(false);\n', '    }\n', '    function wrapToKeth(uint256 wethAmount) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        keth.depositTokens(wethAmount);\n', '    }\n', '    function unwrapKeth(uint256 kethAmount) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        keth.withdrawTokens(kethAmount);\n', '    }\n', '    function addLiquidity(address kethORweth, uint256 ethAmount) public override {\n', '        gate.setUnrestricted(true);\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        addLiq(kethORweth, ethAmount);\n', '        gate.setUnrestricted(false);\n', '    }\n', '    function removeLiquidity (address kethORweth, uint256 tokens) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        gate.setUnrestricted(true);\n', '        removeLiq(kethORweth, tokens);\n', '        gate.setUnrestricted(false);\n', '    }\n', '    function buyRootKit(address token, uint256 amountToSpend) public override {\n', '        gate.setUnrestricted(true);\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        buyRoot(token, amountToSpend);\n', '        gate.setUnrestricted(false);\n', '    }\n', '    function sellRootKit(address token, uint256 amountToSpend) public override {\n', '        require (msg.sender == owner || infinitePumpers[msg.sender], "You Wish!!!");\n', '        gate.setUnrestricted(true);\n', '        sellRoot(token, amountToSpend);\n', '        gate.setUnrestricted(false);\n', '    }\n', '    function addLiq(address kethORweth, uint256 ethAmount) internal {\n', '        uniswapV2Router.addLiquidity(address(kethORweth), address(rootKit), ethAmount, rootKit.balanceOf(address(this)), 0, 0, address(this), block.timestamp);\n', '    }\n', '    function removeLiq(address kethORweth, uint256 tokens) internal returns (uint256) {\n', '        (tokens,) = uniswapV2Router.removeLiquidity(address(kethORweth), address(rootKit), tokens, 0, 0, address(this), block.timestamp);\n', '        return tokens;\n', '    }\n', '    function buyRoot(address token, uint256 amountToSpend) internal {\n', '        uniswapV2Router.swapExactTokensForTokens(amountToSpend, 0, buyPath(token), address(this), block.timestamp);\n', '    }\n', '    function sellRoot(address token, uint256 amountToSpend) internal {\n', '        uniswapV2Router.swapExactTokensForTokens(amountToSpend, 0, sellPath(token), address(this), block.timestamp);\n', '    }\n', '    function buyPath(address token) internal view returns(address[] memory) {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(token);\n', '        path[1] = address(rootKit);\n', '        return path;\n', '    }\n', '    function sellPath(address token) internal view returns(address[] memory) {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(rootKit);\n', '        path[1] = address(token);\n', '        return path;\n', '    }\n', '}']