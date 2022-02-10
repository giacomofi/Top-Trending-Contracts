['/*\n', 'https://powerpool.finance/\n', '\n', '          wrrrw r wrr\n', '         ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0\n', '        rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0\n', '        rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0\n', '        r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0\n', '         prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0\n', '          wrr ww0rrrr\n', '\n', '*/\n', '\n', '// File: contracts/bactions-proxy/BActions.sol\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.12;\n', '\n', 'abstract contract ERC20 {\n', '    function balanceOf(address whom) external view virtual returns (uint);\n', '    function allowance(address, address) external view virtual returns (uint);\n', '    function approve(address spender, uint amount) external virtual returns (bool);\n', '    function transfer(address dst, uint amt) external virtual returns (bool);\n', '    function transferFrom(address sender, address recipient, uint amount) external virtual returns (bool);\n', '}\n', '\n', 'abstract contract BPool is ERC20 {\n', '    function isBound(address t) external view virtual returns (bool);\n', '    function getFinalTokens() external view virtual returns(address[] memory);\n', '    function getBalance(address token) external view virtual returns (uint);\n', '    function setSwapFee(uint swapFee) external virtual;\n', '    function setCommunityFeeAndReceiver(uint swapFee, uint joinFee, uint exitFee, address swapFeeReceiver) external virtual;\n', '    function setController(address controller) external virtual;\n', '    function setPublicSwap(bool public_) external virtual;\n', '    function finalize() external virtual;\n', '    function bind(address token, uint balance, uint denorm) external virtual;\n', '    function rebind(address token, uint balance, uint denorm) external virtual;\n', '    function unbind(address token) external virtual;\n', '    function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external virtual;\n', '    function joinswapExternAmountIn(\n', '        address tokenIn, uint tokenAmountIn, uint minPoolAmountOut\n', '    ) external virtual returns (uint poolAmountOut);\n', '}\n', '\n', 'abstract contract BFactory {\n', '    function newBPool(string calldata name, string calldata symbol) external virtual returns (BPool);\n', '}\n', '\n', '/********************************** WARNING **********************************/\n', '//                                                                           //\n', '// This contract is only meant to be used in conjunction with ds-proxy.      //\n', '// Calling this contract directly will lead to loss of funds.                //\n', '//                                                                           //\n', '/********************************** WARNING **********************************/\n', '\n', 'contract BActions {\n', '\n', '    function create(\n', '        BFactory factory,\n', '        string calldata name,\n', '        string calldata symbol,\n', '        address[] calldata tokens,\n', '        uint[] calldata balances,\n', '        uint[] calldata denorms,\n', '        uint[4] calldata fees,\n', '        address communityFeeReceiver,\n', '        bool finalize\n', '    ) external returns (BPool pool) {\n', '        require(tokens.length == balances.length, "ERR_LENGTH_MISMATCH");\n', '        require(tokens.length == denorms.length, "ERR_LENGTH_MISMATCH");\n', '\n', '        pool = factory.newBPool(name, symbol);\n', '        pool.setSwapFee(fees[0]);\n', '        pool.setCommunityFeeAndReceiver(fees[1], fees[2], fees[3], communityFeeReceiver);\n', '\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            ERC20 token = ERC20(tokens[i]);\n', '            require(token.transferFrom(msg.sender, address(this), balances[i]), "ERR_TRANSFER_FAILED");\n', '            if (token.allowance(address(this), address(pool)) > 0) {\n', '                token.approve(address(pool), 0);\n', '            }\n', '            token.approve(address(pool), balances[i]);\n', '            pool.bind(tokens[i], balances[i], denorms[i]);\n', '        }\n', '\n', '        if (finalize) {\n', '            pool.finalize();\n', '            require(pool.transfer(msg.sender, pool.balanceOf(address(this))), "ERR_TRANSFER_FAILED");\n', '        } else {\n', '            pool.setPublicSwap(true);\n', '        }\n', '\n', '        pool.setController(msg.sender);\n', '    }\n', '\n', '    function setTokens(\n', '        BPool pool,\n', '        address[] calldata tokens,\n', '        uint[] calldata balances,\n', '        uint[] calldata denorms\n', '    ) external {\n', '        require(tokens.length == balances.length, "ERR_LENGTH_MISMATCH");\n', '        require(tokens.length == denorms.length, "ERR_LENGTH_MISMATCH");\n', '\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            ERC20 token = ERC20(tokens[i]);\n', '            if (pool.isBound(tokens[i])) {\n', '                if (balances[i] > pool.getBalance(tokens[i])) {\n', '                    require(\n', '                        token.transferFrom(msg.sender, address(this), balances[i] - pool.getBalance(tokens[i])),\n', '                        "ERR_TRANSFER_FAILED"\n', '                    );\n', '                    if (token.allowance(address(this), address(pool)) > 0) {\n', '                        token.approve(address(pool), 0);\n', '                    }\n', '                    token.approve(address(pool), balances[i] - pool.getBalance(tokens[i]));\n', '                }\n', '                if (balances[i] > 10**6) {\n', '                    pool.rebind(tokens[i], balances[i], denorms[i]);\n', '                } else {\n', '                    pool.unbind(tokens[i]);\n', '                }\n', '\n', '            } else {\n', '                require(token.transferFrom(msg.sender, address(this), balances[i]), "ERR_TRANSFER_FAILED");\n', '                if (token.allowance(address(this), address(pool)) > 0) {\n', '                    token.approve(address(pool), 0);\n', '                }\n', '                token.approve(address(pool), balances[i]);\n', '                pool.bind(tokens[i], balances[i], denorms[i]);\n', '            }\n', '\n', '            if (token.balanceOf(address(this)) > 0) {\n', '                require(token.transfer(msg.sender, token.balanceOf(address(this))), "ERR_TRANSFER_FAILED");\n', '            }\n', '\n', '        }\n', '    }\n', '\n', '    function setPublicSwap(BPool pool, bool publicSwap) external {\n', '        pool.setPublicSwap(publicSwap);\n', '    }\n', '\n', '    function setSwapFee(BPool pool, uint newFee) external {\n', '        pool.setSwapFee(newFee);\n', '    }\n', '\n', '    function setController(BPool pool, address newController) external {\n', '        pool.setController(newController);\n', '    }\n', '\n', '    function finalize(BPool pool) external {\n', '        pool.finalize();\n', '        require(pool.transfer(msg.sender, pool.balanceOf(address(this))), "ERR_TRANSFER_FAILED");\n', '    }\n', '\n', '    function joinPool(\n', '        BPool pool,\n', '        uint poolAmountOut,\n', '        uint[] calldata maxAmountsIn\n', '    ) external {\n', '        address[] memory tokens = pool.getFinalTokens();\n', '        require(maxAmountsIn.length == tokens.length, "ERR_LENGTH_MISMATCH");\n', '\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            ERC20 token = ERC20(tokens[i]);\n', '            require(token.transferFrom(msg.sender, address(this), maxAmountsIn[i]), "ERR_TRANSFER_FAILED");\n', '            if (token.allowance(address(this), address(pool)) > 0) {\n', '                token.approve(address(pool), 0);\n', '            }\n', '            token.approve(address(pool), maxAmountsIn[i]);\n', '        }\n', '        pool.joinPool(poolAmountOut, maxAmountsIn);\n', '        for (uint i = 0; i < tokens.length; i++) {\n', '            ERC20 token = ERC20(tokens[i]);\n', '            if (token.balanceOf(address(this)) > 0) {\n', '                require(token.transfer(msg.sender, token.balanceOf(address(this))), "ERR_TRANSFER_FAILED");\n', '            }\n', '        }\n', '        require(pool.transfer(msg.sender, pool.balanceOf(address(this))), "ERR_TRANSFER_FAILED");\n', '    }\n', '\n', '    function joinswapExternAmountIn(\n', '        BPool pool,\n', '        address tokenIn,\n', '        uint tokenAmountIn,\n', '        uint minPoolAmountOut\n', '    ) external {\n', '        ERC20 token = ERC20(tokenIn);\n', '        require(token.transferFrom(msg.sender, address(this), tokenAmountIn), "ERR_TRANSFER_FAILED");\n', '        if (token.allowance(address(this), address(pool)) > 0) {\n', '            token.approve(address(pool), 0);\n', '        }\n', '        token.approve(address(pool), tokenAmountIn);\n', '        uint poolAmountOut = pool.joinswapExternAmountIn(tokenIn, tokenAmountIn, minPoolAmountOut);\n', '        require(pool.transfer(msg.sender, poolAmountOut), "ERR_TRANSFER_FAILED");\n', '    }\n', '}']