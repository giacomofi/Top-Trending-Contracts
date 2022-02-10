['// SPDX-License-Identifier: LGPL-3.0-or-later\n', 'pragma solidity 0.5.17;\n', '\n', 'import "./Math.sol";\n', 'import "./SafeMath.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./ReentrancyGuard.sol";\n', 'import "./IDextokenPool.sol";\n', 'import "./IDextokenFactory.sol";\n', 'import "./LPToken.sol";\n', '\n', '\n', 'contract DextokenPool is LPToken, IDextokenPool, ReentrancyGuard {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint;\n', '\n', '    /// AMM fee\n', '    uint public constant FEE_BASE      = 10**4; // 0.01%\n', '    uint public constant FEE_FACTOR    = 30;\n', '\n', '    IDextokenFactory public factory;\n', '\n', '    /// The collateral token\n', '    IERC20 public WETH;\n', '\n', '    /// Pooling\n', '    uint public totalLiquidity;\n', '    IERC20 public token0;\n', '\n', '    /// Speculative AMM\n', '    struct AMM {\n', '        uint Ct;\n', '        uint Pt;\n', '        uint Nt;\n', '        uint lastUpdateTime;\n', '    }\n', '\n', '    /// AMM states\n', '    AMM private _AMM;\n', '\n', '    modifier updatePriceTick() {    \n', '        _;\n', '        /// step the price tick (t+1)\n', '        _AMM.lastUpdateTime = _lastPriceTickApplicable();      \n', '    }\n', '\n', '    constructor() public {\n', '        factory = IDextokenFactory(msg.sender);\n', '        _AMM.lastUpdateTime = 0;\n', '        totalLiquidity = 0;\n', '    }\n', '\n', '    function initialize(address _token0, address _token1, uint _Ct, uint _Pt) \n', '        external \n', '    {\n', "        require(msg.sender == address(factory), 'initialize: Forbidden');\n", '\n', '        token0 = IERC20(_token0); \n', '        require(_Ct <= token0.totalSupply(), "initialize: Invalid _Ct");     \n', '        \n', '        /// snapshot of the pooled token\n', '        _AMM.Ct = _Ct;\n', '        _AMM.Pt = _Pt;\n', '        _AMM.Nt = _AMM.Pt.mul(_AMM.Ct).div(1e18);\n', '\n', '        /// The collateral token\n', '        WETH = IERC20(_token1);        \n', '    }\n', '\n', '    function deposit(uint amount) \n', '        external \n', '        nonReentrant\n', '        updatePriceTick()\n', '    {\n', '        require(amount > 0, "deposit: invalid amount");\n', '        uint _totalBalance = getPoolBalance();\n', '        address _token0 = address(token0);\n', '        uint _Ct = _AMM.Ct.add(amount);\n', '        uint _Nt = _AMM.Nt;\n', '\n', '        // liquidity at price tick (t)\n', '        uint spotPrice = getSpotPrice(_Ct, _Nt);\n', '        uint liquidity = spotPrice.mul(amount);\n', '        require(liquidity > 0, "deposit: invalid user liquidity");\n', '\n', '        _totalBalance = _totalBalance.add(amount);\n', '        uint _totalLiquidity = totalLiquidity.add(liquidity);\n', '\n', '        // mint liquidity tokens\n', '        uint mintedTokens = _calcLiquidityToken(_totalLiquidity, _totalBalance, liquidity);\n', '\n', '        /// calculate the virtual collateral tokens at price tick (t)\n', '        uint _Mb = WETH.balanceOf(address(this)).mul(mintedTokens).div(totalSupply().add(mintedTokens));\n', '\n', '        // move price tick to (t+1) \n', '        _AMM.Ct = _Ct;\n', '        _AMM.Nt = _Nt.add(_Mb);\n', '        totalLiquidity = _totalLiquidity;\n', '\n', '        // mint liquidity token at price tick (t+1)\n', '        _mintLiquidityToken(msg.sender, mintedTokens);\n', '        _tokenSafeTransferFrom(_token0, msg.sender, address(this), amount);\n', '        emit TokenDeposit(_token0, msg.sender, amount, spotPrice);        \n', '    }\n', '\n', '    function withdraw(uint tokens) \n', '        external \n', '        nonReentrant\n', '        updatePriceTick()\n', '    {\n', '        require(tokens > 0, "withdraw: invalid tokens");\n', '        require(totalSupply() > 0, "withdraw: insufficient liquidity");\n', '        require(balanceOf(msg.sender) >= tokens, "withdraw: insufficient tokens");\n', '        address _token0 = address(token0);\n', '      \n', '        // liquidity at price tick (t)\n', '        uint amount = liquidityTokenToAmount(tokens);\n', '\n', '        /// calculate the collateral token shares\n', '        uint balance = WETH.balanceOf(address(this));\n', '        uint amountOut = balance.mul(tokens).div(totalSupply());\n', '\n', '        /// Ensure the amountOut is not more than the balance in the contract.\n', '        /// Preventing underflow due to very low values of the balance.        \n', '        require(amountOut <= balance, "withdraw: insufficient ETH balance");\n', '\n', '        // prepare for price tick (t+1)\n', '        uint _Ct = _AMM.Ct;\n', '        uint _Nt = _AMM.Nt;\n', '        _Ct = _Ct.sub(amount);\n', '        _Nt = _Nt.sub(amountOut);\n', '\n', '        // liquidity at price tick (t+1)        \n', '        uint spotPrice = getSpotPrice(_Ct, _Nt);\n', '        totalLiquidity = spotPrice.mul(getPoolBalance().sub(amount));\n', '\n', '        _AMM.Ct = _Ct;\n', '        _AMM.Nt = _Nt;\n', '\n', '        _tokenSafeTransfer(_token0, msg.sender, amount);\n', '        _tokenSafeTransfer(address(WETH), msg.sender, amountOut);\n', '\n', '        _burnLiquidityToken(msg.sender, tokens);\n', '        emit TokenWithdraw(_token0, msg.sender, amount, spotPrice);\n', '    }\n', '\n', '    function swapExactETHForTokens(\n', '        uint amountIn,\n', '        uint minAmountOut,\n', '        uint maxPrice,\n', '        uint deadline\n', '    )\n', '        external \n', '        nonReentrant\n', '        returns (uint)\n', '    {\n', '        require(WETH.balanceOf(msg.sender) >= amountIn, "swapExactETHForTokens: Insufficient ETH balance");\n', '        require(deadline > _lastPriceTickApplicable(), "swapExactETHForTokens: Invalid transaction");\n', '        require(amountIn > 0, "swapExactETHForTokens: Invalid amountIn");\n', '        uint spotPrice;\n', '        IERC20 _WETH = WETH;\n', '\n', '        /// the price tick at (t)\n', '        /// increase the collateral token supply including interests rate        \n', '        {\n', '            spotPrice = getSpotPrice(_AMM.Ct, _AMM.Nt.add(amountIn));\n', '            require(spotPrice <= maxPrice, "swapExactETHForTokens: Invalid price slippage");\n', '        }\n', '\n', '        /// check amount out without fees\n', '        uint amountOut = amountIn.mul(1e18).div(spotPrice);\n', '        require(amountOut >= minAmountOut, "swapExactETHForTokens: Invalid amountOut");\n', '\n', '        /// split fees and check exact amount out\n', '        uint feeAmountIn = _calcFees(amountIn);\n', '        uint exactAmountIn = amountIn.sub(feeAmountIn);\n', '        uint exactAmountOut = exactAmountIn.mul(1e18).div(spotPrice);\n', '\n', '        /// increase the collateral token supply\n', '        _AMM.Nt = _AMM.Nt.add(exactAmountIn);\n', '        spotPrice = getSpotPrice(_AMM.Ct.sub(exactAmountOut), _AMM.Nt);\n', '        totalLiquidity = spotPrice.mul(getPoolBalance().sub(exactAmountOut));\n', '\n', '        /// transfer the collateral tokens in\n', '        _tokenSafeTransferFrom(address(_WETH), msg.sender, address(this), amountIn);\n', '        \n', '        /// transfer fees\n', '        _tokenSafeTransfer(address(_WETH), factory.getFeePool(), feeAmountIn);\n', '\n', '        /// move to the next price tick (t+1)\n', '        _withdrawAndTransfer(msg.sender, exactAmountOut);\n', '\n', '        emit SwapExactETHForTokens(address(this), exactAmountOut, amountIn, spotPrice, msg.sender);\n', '        return exactAmountOut;\n', '    } \n', '\n', '    function swapExactTokensForETH(\n', '        uint amountIn,\n', '        uint minAmountOut,\n', '        uint minPrice,\n', '        uint deadline\n', '    )\n', '        external \n', '        nonReentrant\n', '        returns (uint)\n', '    {\n', '        require(token0.balanceOf(msg.sender) >= amountIn, "swapExactTokensForETH: Insufficient user balance");    \n', '        require(deadline > _lastPriceTickApplicable(), "swapExactTokensForETH: Invalid order");\n', '        require(amountIn > 0, "swapExactTokensForETH: Invalid amountIn");\n', '        uint _Nt = _AMM.Nt;\n', '        IERC20 _WETH = WETH;\n', '\n', '        /// add liquidity at the price tick (t)\n', '        uint spotPrice = getSpotPrice(_AMM.Ct.add(amountIn), _Nt);\n', '        require(spotPrice >= minPrice, "swapExactTokensForETH: Invalid price slippage");\n', '\n', '        /// user receives\n', '        uint amountOut = spotPrice.mul(amountIn).div(1e18);\n', '        require(_WETH.balanceOf(address(this)) >= amountOut, "swapExactTokensForETH: Insufficient ETH liquidity");\n', '        require(amountOut >= minAmountOut, "swapExactTokensForETH: Invalid amountOut");\n', '\n', '        /// split fees\n', '        uint feeAmountOut = _calcFees(amountOut);\n', '        uint exactAmountOut = amountOut.sub(feeAmountOut);\n', '\n', '        /// decrease the collateral token, and add liquidity \n', "        /// providers' fee shares back to the pool\n", '        _AMM.Nt = _Nt.sub(exactAmountOut);\n', '\n', '        totalLiquidity = spotPrice.mul(getPoolBalance().add(amountIn));\n', '\n', '        /// move the next price tick (t+1)\n', '        _depositAndTransfer(msg.sender, amountIn);\n', '\n', '        /// transfer the collateral token out\n', '        _tokenSafeTransfer(address(_WETH), msg.sender, exactAmountOut);\n', '\n', '        emit SwapExactTokensForETH(address(this), exactAmountOut, amountIn, spotPrice, msg.sender);\n', '        return exactAmountOut;\n', '    }\n', '\n', '    function getLastUpdateTime() external view returns (uint) {\n', '        return _AMM.lastUpdateTime;\n', '    }  \n', '\n', '    function getCirculatingSupply() external view returns (uint) {\n', '        return _AMM.Ct;\n', '    }    \n', '\n', '    function getUserbase() external view returns (uint) {\n', '        return _AMM.Nt;\n', '    }\n', '\n', '    function getToken() external view returns (address) {\n', '        return address(token0);\n', '    }\n', '\n', '    function getTotalLiquidity() external view returns (uint) {\n', '        return totalLiquidity.div(1e18);\n', '    }  \n', '\n', '    function liquidityOf(address account) external view returns (uint) {\n', '        return balanceOf(account);\n', '    }\n', '\n', '    function liquiditySharesOf(address account) external view returns (uint) {\n', '        uint userTokens = balanceOf(account);\n', '        if (userTokens == 0) {\n', '            return 0;\n', '        }\n', '        return totalSupply()\n', '            .mul(1e18)\n', '            .div(userTokens);\n', '    }  \n', '\n', '    function mean() public view returns (uint) {\n', '        return _AMM.Nt\n', '            .mul(_AMM.Pt);\n', '    }\n', '\n', '    function getPoolBalance() public view returns (uint) {\n', '        return token0.balanceOf(address(this));\n', '    }\n', '\n', '    function getPrice() public view returns (uint) {\n', '        return _AMM.Nt.mul(1e18).div(_AMM.Ct);\n', '    }   \n', '\n', '    function getSpotPrice(uint _Ct, uint _Nt) public pure returns (uint) {\n', '        return _Nt.mul(1e18).div(_Ct);\n', '    }\n', '\n', '    function liquidityTokenToAmount(uint token) public view returns (uint) {\n', '        if (totalSupply() == 0) {\n', '            return 0;\n', '        }        \n', '        return getPoolBalance()\n', '            .mul(token)\n', '            .div(totalSupply());\n', '    }  \n', '\n', '    function liquidityFromAmount(uint amount) public view returns (uint) {\n', '        return getPrice().mul(amount); \n', '    }\n', '\n', '    function _depositAndTransfer(address account, uint amount) \n', '        internal\n', '        updatePriceTick()\n', '    {\n', '        _AMM.Ct = _AMM.Ct.add(amount);    \n', '        _tokenSafeTransferFrom(address(token0), account, address(this), amount);\n', '    }\n', '\n', '    function _withdrawAndTransfer(address account, uint amount) \n', '        internal\n', '        updatePriceTick()\n', '    {\n', '        _AMM.Ct = _AMM.Ct.sub(amount);    \n', '        _tokenSafeTransfer(address(token0), account, amount);\n', '    }\n', '    \n', '    function _lastPriceTickApplicable() internal view returns (uint) {\n', '        return Math.max(block.timestamp, _AMM.lastUpdateTime);\n', '    }\n', '\n', '    function _mintLiquidityToken(address to, uint amount) internal {\n', '        _mint(address(this), amount);\n', '        _transfer(address(this), to, amount);\n', '    }\n', '\n', '    function _burnLiquidityToken(address from, uint amount) internal {\n', '        _transfer(from, address(this), amount);\n', '        _burn(address(this), amount);\n', '    } \n', '\n', '    function _calcFees(uint amount) internal pure returns (uint) {\n', '        return amount.mul(FEE_FACTOR).div(FEE_BASE);\n', '    }\n', '\n', '    function _calcLiquidityToken(\n', '        uint _totalLiquidity, \n', '        uint _totalBalance, \n', '        uint _liquidity\n', '    ) \n', '        internal \n', '        pure \n', '        returns (uint) \n', '    {\n', '        if (_totalLiquidity == 0) {\n', '            return 0;\n', '        }    \n', '        return _totalBalance\n', '            .mul(_liquidity)\n', '            .div(_totalLiquidity);\n', '    }\n', '\n', '    function _tokenSafeTransfer(\n', '        address token,\n', '        address to,\n', '        uint amount\n', '    ) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, amount));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "_tokenSafeTransfer failed");\n', '    }\n', '\n', '    function _tokenSafeTransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint amount\n', '    ) internal {\n', '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, amount));\n', '        require(success && (data.length == 0 || abi.decode(data, (bool))), "_tokenSafeTransferFrom failed");\n', '    }                    \n', '}']