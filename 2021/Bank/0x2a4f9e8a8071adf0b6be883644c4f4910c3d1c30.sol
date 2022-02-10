['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-29\n', '*/\n', '\n', '//SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.7.0;\n', '\n', 'interface IUniswap {\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    \n', '    function getAmountsOut(\n', '        uint amountIn, \n', '        address[] memory path\n', '    ) external returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(\n', '        address recipient, \n', '        uint256 amount\n', '    ) external returns (bool);\n', '    \n', '    function approve(\n', '        address spender, \n', '        uint256 amount\n', '    ) external returns (bool);\n', '    \n', '    function balanceOf(\n', '        address account\n', '    ) external view returns (uint256);\n', '}\n', '\n', 'contract Swap {\n', '    address owner;\n', '    mapping(address => bool) private whitelistedMap;\n', '\n', '    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    \n', '    IUniswap public uniswapRouter;\n', '    \n', '    event Swap(address indexed account, address[] indexed path, uint amountIn, uint amountOut);\n', '\n', '    // MODIFIERS\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onWhiteList {\n', '        require(whitelistedMap[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    constructor() {\n', '        uniswapRouter = IUniswap(UNISWAP_ROUTER_ADDRESS);\n', '        owner = msg.sender;\n', '        setAddress(owner,true);\n', '    }\n', '\n', '    function setAddress(address _address,bool flag) public onlyOwner {\n', '        whitelistedMap[_address] = flag;\n', '    }\n', '    // WITHDRAW\n', '    function withdrawToken(address to,address token) external onlyOwner {\n', '        require(IERC20(token).balanceOf(address(this)) > 0);\n', '        IERC20(token).transfer(to, IERC20(token).balanceOf(address(this)));\n', '    }\n', '\n', '    // GET BALANCE\n', '    function getTokenBalance(address token) public view onWhiteList returns (uint256){\n', '        return IERC20(token).balanceOf(address(this));\n', '    }\n', '\n', '    // SWAP\n', '    function tradeIn(\n', '        uint amountIn,uint amountMinOut,\n', '        address[] calldata path\n', '    ) external onWhiteList {\n', '        uint256 amount=getTokenBalance(path[0]);//token balance\n', '        if(amount>=amountIn){\n', '            uint256[] memory amounts = getAmountOut(amountIn, path);\n', '            if(amounts[amounts.length - 1]>=amountMinOut){\n', '                IERC20(path[0]).approve(address(uniswapRouter), amountIn);\n', '                uniswapRouter.swapExactTokensForTokens(\n', '                amountIn,\n', '                amountMinOut,\n', '                path,\n', '                address(this),\n', '                block.timestamp + 60*30\n', '                );\n', '            }\n', '            emit Swap(msg.sender, path, amountIn, amounts[amounts.length - 1]);\n', '        }\n', '        \n', '\n', '    }\n', '    function tradeOut(\n', '        address[] calldata path,uint amountMinOut\n', '    ) external onWhiteList {\n', '        uint256 amount=getTokenBalance(path[0]);//token balance\n', '        \n', '        if(amount>0){\n', '            uint256[] memory amounts = getAmountOut(amount, path);\n', '            if(amounts[amounts.length - 1]>=amountMinOut){\n', '                IERC20(path[0]).approve(address(uniswapRouter), amount);\n', '                uniswapRouter.swapExactTokensForTokens(\n', '                amount,\n', '                amountMinOut,\n', '                path,\n', '                address(this),\n', '                block.timestamp + 60*30\n', '                );\n', '            }\n', '            emit Swap(msg.sender, path, amount, amounts[amounts.length - 1]);\n', '        }\n', '        \n', '    }\n', '    \n', '    \n', '    // UTILS    \n', '    function getAmountOut(uint amountIn, address[] memory path) private returns(uint256[] memory){\n', '        return uniswapRouter.getAmountsOut(amountIn, path);\n', '    }\n', '}']