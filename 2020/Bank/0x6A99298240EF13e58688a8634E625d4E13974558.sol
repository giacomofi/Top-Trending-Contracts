['// SPDX-License-Identifier: MIT;\n', 'pragma solidity =0.7.0;\n', '\n', 'interface Uniswap {\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external returns (uint256[] memory amounts);\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address guy) external view returns (uint256);\n', '    function transfer(address dst, uint256 wad) external returns (bool);\n', '    function transferFrom(address src, address dst, uint256 wad) external returns (bool);\n', '    function approve(address guy, uint256 wad) external returns (bool);\n', '    function allowance(address src, address dst) external view returns (uint256);\n', '}\n', '\n', 'contract UniswapWrapper {\n', '    address private janitor;\n', '    address constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address constant uniswap = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '\n', '    constructor() {\n', '        janitor = msg.sender;\n', '    }\n', '\n', '    function swap(\n', '        address token_in,\n', '        address token_out,\n', '        uint256 amount_in,\n', '        uint256 min_amount_out,\n', '        address to\n', '    ) external returns (bool) {\n', '        IERC20 token = IERC20(token_in);\n', '        token.transferFrom(msg.sender, address(this), amount_in);\n', '\n', '        bool is_weth = token_in == weth || token_out == weth;\n', '        address[] memory path = new address[](is_weth ? 2 : 3);\n', '        path[0] = token_in;\n', '        if (is_weth) {\n', '            path[1] = token_out;\n', '        } else {\n', '            path[1] = weth;\n', '            path[2] = token_out;\n', '        }\n', '\n', '        if (token.allowance(address(this), uniswap) == 0) {\n', '            token.approve(uniswap, type(uint256).max);\n', '        }\n', '        Uniswap(uniswap).swapExactTokensForTokens(\n', '            amount_in,\n', '            min_amount_out,\n', '            path,\n', '            to,\n', '            block.timestamp\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function dust(address _token) external returns (bool) {\n', '        IERC20 token = IERC20(_token);\n', '        return token.transfer(janitor, token.balanceOf(address(this)));\n', '    }\n', '}']