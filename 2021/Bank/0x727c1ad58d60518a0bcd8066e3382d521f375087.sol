['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-19\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', 'interface IUniswapV2Router02 {\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'contract AutoSwap {\n', '    address private _admin;\n', '    IUniswapV2Router02 constant uniV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address public token;\n', '    \n', '    modifier onlyAdmin() {\n', '        require(msg.sender == _admin, "Not admin");\n', '        _;\n', '    }\n', '    \n', '    constructor(address _token) {\n', '        _admin = msg.sender;\n', '        token = _token;\n', '    }\n', '    \n', '    function exchange() external payable returns (bool) {\n', '        address[] memory path = new address[](2);\n', '        path[0] = WETH;\n', '        path[1] = token;\n', '        uniV2Router02.swapExactETHForTokens{value:msg.value}(1, path, msg.sender, type(uint256).max);\n', '        return true;\n', '    }\n', '    \n', '    function setAdmin(address newAdmin) external onlyAdmin {\n', '        _admin = newAdmin;\n', '    }\n', '    \n', '    function seize(address _token, address to) external onlyAdmin returns (bool) {\n', '        if (_token != address(0)) {\n', '            uint256 amount = IERC20(_token).balanceOf(address(this));\n', '            IERC20(_token).transfer(to, amount);\n', '        }\n', '        else {\n', '            uint256 amount = address(this).balance;\n', '            payable(to).transfer(amount);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    fallback () external payable { }\n', '    receive () external payable { }\n', '}']