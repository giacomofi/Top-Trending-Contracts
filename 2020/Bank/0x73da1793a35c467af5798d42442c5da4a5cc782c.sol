['// SPDX-License-Identifier: MIT\n', '\n', '// Created by 0xce16989f81D7dC03F8826ADE02108aFe9160cc54\n', '\n', '//Built for educational purposes. Not audited. Use at your own risk.\n', '\n', '// Need help? support@proofsuite.com\n', '\n', '\n', 'pragma solidity >= 0.6.6;\n', '\n', 'interface bzxRead {\n', '\n', '    function getLoan(bytes32 loanId) external view returns(bytes32 loanId1, uint96 endTimestamp, address loanToken, address collateralToken, uint256 principal, uint256 collateral, uint256 interestOwedPerDay, uint256 interestDepositRemaining, uint256 startRate, uint256 startMargin, uint256 maintenanceMargin, uint256 currentMargin, uint256 maxLoanTerm, uint256 maxLiquidatable, uint256 maxSeizable);\n', '}\n', '\n', 'interface bzxWrite {\n', '    function liquidate(bytes32 loanId, address receiver, uint256 closeAmount) payable external;\n', '\n', '}\n', '\n', '\n', 'interface UniswapV2 {\n', '\n', '\n', '    function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns(uint256 amountA, uint256 amountB, uint256 liquidity);\n', '\n', '    function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns(uint256 amountToken, uint256 amountETH, uint256 liquidity);\n', '\n', '    function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns(uint256 amountToken, uint256 amountETH);\n', '\n', '    function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns(uint256 amountA, uint256 amountB);\n', '\n', '    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns(uint256[] memory amounts);\n', '\n', '    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns(uint256[] memory amounts);\n', '\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);\n', '\n', '}\n', '\n', '\n', 'interface FlashLoanInterface {\n', '    function flashLoan(address _receiver, address _reserve, uint256 _amount, bytes calldata _params) external;\n', '}\n', '\n', '\n', '\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns(uint supply);\n', '\n', '    function balanceOf(address _owner) external view returns(uint balance);\n', '\n', '    function transfer(address _to, uint _value) external returns(bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint _value) external returns(bool success);\n', '\n', '    function approve(address _spender, uint _value) external returns(bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns(uint remaining);\n', '\n', '    function decimals() external view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '\n', '    function deposit() external payable;\n', '\n', '    function withdraw(uint256 wad) external;\n', '}\n', '\n', '\n', '\n', '\n', 'contract BZXAAVEFLASHLIQUIDATE {\n', '    address payable owner;\n', '    address ETH_TOKEN_ADDRESS = address(0x0);\n', '    address payable aaveRepaymentAddress = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;\n', '\n', '    address uniAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    bzxRead bzx0 = bzxRead(0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f);\n', '\n', '    address bzx1Address = 0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f;\n', '\n', '    bzxWrite bzx1 = bzxWrite(0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f);\n', '    UniswapV2 usi = UniswapV2(uniAddress);\n', '    FlashLoanInterface fli = FlashLoanInterface(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);\n', '    bytes theBytes;\n', '\n', '\n', '    address aaveEthAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; \n', '    address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    ERC20 wethToken = ERC20(wethAddress);\n', '    address currentCToken;\n', '    address currentLToken;\n', '\n', '    uint256 currentMaxLiq;\n', '    bytes32 currentLoanId;\n', '\n', '\n', '\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender == owner) _;\n', '    }\n', '\n', '\n', '\n', '    constructor() public payable {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    fallback() external payable {\n', '\n', '    }\n', '\n', '\n', '    function updateBZXs(address newAddress) onlyOwner public {\n', '        bzxRead bzx0 = bzxRead(newAddress);\n', '\n', '        address bzx1Address = newAddress;\n', '\n', '        bzxWrite bzx1 = bzxWrite(newAddress);\n', '    }\n', '\n', '    function updateFlashLoanAddress(address newAddress) onlyOwner public {\n', '        FlashLoanInterface fli = FlashLoanInterface(newAddress);\n', '    }\n', '\n', '\n', '    function updateAaveEthAddress(address newAddress) onlyOwner public {\n', '        aaveEthAddress = newAddress;\n', '    }\n', '\n', '\n', '    function updateAaveRepayment(address payable newAddress) onlyOwner public {\n', '        aaveRepaymentAddress = newAddress;\n', '    }\n', '\n', '    function updateUniAddress(address newAddress) onlyOwner public {\n', '        UniswapV2 usi = UniswapV2(newAddress);\n', '    }\n', '\n', '    function setLoanInfo(address cToken, address lToken, uint maxLiq, bytes32 loanId2) public onlyOwner {\n', '        currentCToken = cToken;\n', '        currentLToken = lToken;\n', '        currentMaxLiq = maxLiq;\n', '        currentLoanId = loanId2;\n', '    }\n', '\n', '    function getLoanInfo1(bytes32 loanId) public view returns(bytes32 loanId1, address loanToken, address collateralToken, uint256 principal, uint256 collateral, uint256 maxLiquidatable) {\n', '        //  return bzx0.getLoan(loanId);\n', '        (bytes32 loanId1, , address loanToken, address collateralToken, uint256 principal, uint256 collateral, , , , , , , , uint256 maxLiquidatable, ) = bzx0.getLoan(loanId);\n', '        return (loanId1, loanToken, collateralToken, principal, collateral, maxLiquidatable);\n', '    }\n', '\n', '\n', '\n', '    function flashLoanAndLiquidate(bytes32 loanId) onlyOwner public {\n', '        //getLoan\n', '        //get amount  and which token you need to pay / flash loan borrow\n', '        (bytes32 loanId1, uint96 endTimestamp, address loanToken, address collateralToken, uint256 principal, uint256 collateral, , , , , , uint256 currentMargin, uint256 maxLoanTerm, uint256 maxLiquidatable, uint256 maxSeizable) = bzx0.getLoan(loanId);\n', '        currentCToken = collateralToken;\n', '        currentLToken = loanToken;\n', '        currentMaxLiq = maxLiquidatable;\n', '        currentLoanId = loanId;\n', '\n', '        address tokenAddToUse = loanToken;\n', '        if (loanToken == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) { //if loantoken == wETH > \n', '            tokenAddToUse = aaveEthAddress;\n', '        }\n', '\n', '        performFlash(tokenAddToUse, maxLiquidatable);\n', '        //flash borrow that amount\n', '\n', '        //and then flash function will call bzx liquidate function, swap the returned token from to our repayment token of aave, and pay back avave with fee\n', '\n', '\n', '    }\n', '\n', '    function performFlash(address tokenAddToUse, uint maxLiquidatable) public onlyOwner {\n', '        fli.flashLoan(address(this), tokenAddToUse, maxLiquidatable, theBytes);\n', '    }\n', '\n', '\n', '\n', '    function performUniswap(address sellToken, address buyToken, uint256 amountSent) public returns(uint256 amounts1) {\n', '\n', '\n', '        ERC20 sellToken1 = ERC20(sellToken);\n', '        ERC20 buyToken1 = ERC20(currentLToken);\n', '\n', '       if (sellToken1.allowance(address(this), uniAddress) <= amountSent) {\n', '\n', '            sellToken1.approve(uniAddress, 100000000000000000000000000000000000);\n', '\n', '       }\n', '\n', '\n', '\n', '        require(sellToken1.balanceOf(address(this)) >= amountSent, "You dont have enough Ctoken to perform this in performUniswap");\n', '\n', '\n', '        address[] memory addresses = new address[](2);\n', '\n', '        addresses[0] = sellToken;\n', '        addresses[1] = buyToken;\n', '\n', '\n', '\n', '        uint256[] memory amounts = performUniswapActual(addresses, amountSent);\n', '        uint256 resultingTokens = amounts[1];\n', '        return resultingTokens;\n', '\n', '    }\n', '\n', '    function performUniswapActual(address[] memory theAddresses, uint amount) public returns(uint256[] memory amounts1) {\n', '\n', '\n', '\n', '        //uint256  amounts = uniswapContract.getAmountsOut(amount,theAddresses );\n', '        uint256 deadline = 1000000000000000;\n', '\n', '        uint256[] memory amounts = usi.swapExactTokensForTokens(amount, 1, theAddresses, address(this), deadline);\n', '\n', '\n', '        return amounts;\n', '\n', '    }\n', '\n', '\n', '\n', '    function performTrade(bool isItEther, uint256 amount1) public returns(uint256) {\n', '\n', '\n', '        uint256 startingETHBalance = address(this).balance;\n', '        ERC20 tokenToReceive = ERC20(currentCToken);\n', '        uint256 startingCBalance = tokenToReceive.balanceOf(address(this));\n', '\n', '        if (isItEther == true) {\n', '\n', '        } else {\n', '            ERC20 bzLToken = ERC20(currentLToken);\n', '\n', '            if (bzLToken.allowance(address(this), bzx1Address) <= currentMaxLiq) {\n', '                bzLToken.approve(bzx1Address, (currentMaxLiq * 100));\n', '            }\n', '        }\n', '\n', '        if (isItEther == false) {\n', '            bzx1.liquidate(currentLoanId, address(this), currentMaxLiq);\n', '        } else {\n', '            bzx1.liquidate {value: amount1}(currentLoanId, address(this), currentMaxLiq);\n', '        }\n', '\n', '\n', '\n', '        uint256 amountBack = 0;\n', '        if (address(this).balance > startingETHBalance) {\n', '            uint256 newETH = address(this).balance - startingETHBalance;\n', '            wethToken.deposit {value: newETH}();\n', '\n', '\n', '            amountBack = performUniswap(wethAddress, currentLToken, newETH);\n', '        }\n', '        else {\n', '\n', '\n', '\n', '            uint256 difCBalance = tokenToReceive.balanceOf(address(this)) - startingCBalance;\n', '           require(difCBalance >0, "Balance of Collateral token didnt go up after swap didnt go up");\n', '\n', '\n', '           amountBack = performUniswap(currentCToken, currentLToken, difCBalance);\n', '        }\n', '\n', '        return amountBack;\n', '\n', '    }\n', '\n', '\n', '    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external {\n', '        bool isEther;\n', '        if (_reserve == aaveEthAddress) {\n', '            isEther = true;\n', '        } else {\n', '            isEther = false;\n', '        }\n', '\n', '\n', '\n', '        uint256 tradeResp = performTrade(isEther, _amount);\n', '        require(tradeResp > 0, "You didnt fet anything from uni");\n', '\n', '        if (_reserve == aaveEthAddress) {\n', '\n', '            uint256 repayAmount = (_amount + _fee);\n', '            uint256 ourEthBalance = address(this).balance;\n', '\n', '\n', '            wethToken.withdraw((_amount + _fee));\n', '            require(tradeResp >= (repayAmount / 10), "Not enough eth");\n', '\n', '            //aaveRepaymentAddress.call.value(repayAmount)();\n', '\n', '        \n', '            aaveRepaymentAddress.call{value: repayAmount}("");\n', '            \n', '\n', '            \n', '\n', '            // aaveRepaymentAddress.send((_amount+_fee));\n', '\n', '        } else {\n', '            ERC20 firstToken = ERC20(_reserve);\n', '            firstToken.transfer(aaveRepaymentAddress, (_amount + _fee));\n', '        }\n', '\n', '\n', '\n', '\n', '    }\n', '\n', '    function getTokenBalance(address tokenAddress) public view returns(uint256) {\n', '        ERC20 theToken = ERC20(tokenAddress);\n', '        return theToken.balanceOf(address(this));\n', '    }\n', '\n', '\n', '\n', '\n', '    // send token 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE if you want to withdraw ether\n', '    function withdraw(address token) public onlyOwner returns(bool) {\n', '\n', '\n', '\n', '    //for ether withdrawal from smart contract\n', '        if (address(token) == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {\n', '            uint256 amount = address(this).balance;\n', '            msg.sender.transfer(amount);\n', '\n', '        }\n', '        //for ether withdrawal from smart contract.\n', '        else {\n', '            ERC20 tokenToken = ERC20(token);\n', '            uint256 tokenBalance = tokenToken.balanceOf(address(this));\n', '            require(tokenToken.transfer(msg.sender, (tokenBalance)));\n', '\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function kill() virtual public {\n', '        if (msg.sender == owner) {\n', '            selfdestruct(owner);\n', '        }\n', '    }\n', '}']