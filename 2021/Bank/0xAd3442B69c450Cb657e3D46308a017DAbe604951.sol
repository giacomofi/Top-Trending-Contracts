['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', "import './interfaces/IERC20.sol';\n", "import './interfaces/IMistXJar.sol';\n", "import './interfaces/IUniswap.sol';\n", "import './libraries/SafeERC20.sol';\n", '\n', '\n', '/// @author Nathan Worsley (https://github.com/CodeForcer)\n', '/// @title MistX Gasless Router\n', 'contract MistXRouter {\n', '  /***********************\n', '  + Global Settings      +\n', '  ***********************/\n', '\n', '  using SafeERC20 for IERC20;\n', '\n', '  IMistXJar MistXJar;\n', '\n', '  address public owner;\n', '  mapping (address => bool) public managers;\n', '\n', '  receive() external payable {}\n', '  fallback() external payable {}\n', '\n', '  /***********************\n', '  + Structures           +\n', '  ***********************/\n', '\n', '  struct Swap {\n', '    uint256 amount0;\n', '    uint256 amount1;\n', '    address[] path;\n', '    address to;\n', '    uint256 deadline;\n', '  }\n', '\n', '  /***********************\n', '  + Swap wrappers        +\n', '  ***********************/\n', '\n', '  function swapExactETHForTokens(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    MistXJar.deposit{value: _bribe}();\n', '\n', '    _router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value - _bribe}(\n', '      _swap.amount1,\n', '      _swap.path,\n', '      _swap.to,\n', '      _swap.deadline\n', '    );\n', '  }\n', '\n', '  function swapETHForExactTokens(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    MistXJar.deposit{value: _bribe}();\n', '\n', '    _router.swapETHForExactTokens{value: msg.value - _bribe}(\n', '      _swap.amount1,\n', '      _swap.path,\n', '      _swap.to,\n', '      _swap.deadline\n', '    );\n', '\n', '    // Refunded ETH needs to be swept from router to user address\n', '    (bool success, ) = payable(_swap.to).call{value: address(this).balance}("");\n', '    require(success);\n', '  }\n', '\n', '  function swapExactTokensForTokens(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    MistXJar.deposit{value: _bribe}();\n', '\n', '    IERC20 from = IERC20(_swap.path[0]);\n', '    from.safeTransferFrom(msg.sender, address(this), _swap.amount0);\n', '    from.safeIncreaseAllowance(address(_router), _swap.amount0);\n', '\n', '    _router.swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '      _swap.amount0,\n', '      _swap.amount1,\n', '      _swap.path,\n', '      _swap.to,\n', '      _swap.deadline\n', '    );\n', '  }\n', '\n', '  function swapTokensForExactTokens(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    MistXJar.deposit{value: _bribe}();\n', '\n', '    IERC20 from = IERC20(_swap.path[0]);\n', '    from.safeTransferFrom(msg.sender, address(this), _swap.amount1);\n', '    from.safeIncreaseAllowance(address(_router), _swap.amount1);\n', '\n', '    _router.swapTokensForExactTokens(\n', '      _swap.amount0,\n', '      _swap.amount1,\n', '      _swap.path,\n', '      _swap.to,\n', '      _swap.deadline\n', '    );\n', '\n', '    from.safeTransfer(msg.sender, from.balanceOf(address(this)));\n', '  }\n', '\n', '  function swapTokensForExactETH(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    IERC20 from = IERC20(_swap.path[0]);\n', '    from.safeTransferFrom(msg.sender, address(this), _swap.amount1);\n', '    from.safeIncreaseAllowance(address(_router), _swap.amount1);\n', '\n', '    _router.swapTokensForExactETH(\n', '      _swap.amount0,\n', '      _swap.amount1,\n', '      _swap.path,\n', '      address(this),\n', '      _swap.deadline\n', '    );\n', '\n', '    MistXJar.deposit{value: _bribe}();\n', '  \n', '    // ETH after bribe must be swept to _to\n', '    (bool success, ) = payable(_swap.to).call{value: address(this).balance}("");\n', '    require(success);\n', '\n', '    // Left-over from tokens must be swept to _to\n', '    from.safeTransfer(msg.sender, from.balanceOf(address(this)));\n', '  }\n', '\n', '  function swapExactTokensForETH(\n', '    Swap calldata _swap,\n', '    IUniswapRouter _router,\n', '    uint256 _bribe\n', '  ) external payable {\n', '    IERC20 from = IERC20(_swap.path[0]);\n', '    from.safeTransferFrom(msg.sender, address(this), _swap.amount0);\n', '    from.safeIncreaseAllowance(address(_router), _swap.amount0);\n', '\n', '    _router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '      _swap.amount0,\n', '      _swap.amount1,\n', '      _swap.path,\n', '      address(this),\n', '      _swap.deadline\n', '    );\n', '\n', '    MistXJar.deposit{value: _bribe}();\n', '  \n', '    // ETH after bribe must be swept to _to\n', '    (bool success, ) = payable(_swap.to).call{value: address(this).balance}("");\n', '    require(success);\n', '  }\n', '\n', '  /***********************\n', '  + Administration       +\n', '  ***********************/\n', '\n', '  event OwnershipChanged(\n', '    address indexed oldOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  constructor(\n', '    address _mistJar\n', '  ) {\n', '    MistXJar = IMistXJar(_mistJar);\n', '    owner = msg.sender;\n', '    managers[msg.sender] = true;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner, "Only the owner can call this");\n', '    _;\n', '  }\n', '\n', '  modifier onlyManager() {\n', '    require(managers[msg.sender] == true, "Only managers can call this");\n', '    _;\n', '  }\n', '\n', '  function addManager(\n', '    address _manager\n', '  ) external onlyOwner {\n', '    managers[_manager] = true;\n', '  }\n', '\n', '  function removeManager(\n', '    address _manager\n', '  ) external onlyOwner {\n', '    managers[_manager] = false;\n', '  }\n', '\n', '  function changeJar(\n', '    address _mistJar\n', '  ) public onlyManager {\n', '    MistXJar = IMistXJar(_mistJar);\n', '  }\n', '\n', '  function changeOwner(\n', '    address _owner\n', '  ) public onlyOwner {\n', '    emit OwnershipChanged(owner, _owner);\n', '    owner = _owner;\n', '  }\n', '\n', '  function rescueStuckETH(\n', '    uint256 _amount,\n', '    address _to\n', '  ) external onlyManager {\n', '    payable(_to).transfer(_amount);\n', '  }\n', '\n', '  function rescueStuckToken(\n', '    address _tokenContract,\n', '    uint256 _value,\n', '    address _to\n', '  ) external onlyManager {\n', '    IERC20(_tokenContract).safeTransfer(_to, _value);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', 'interface IERC20 {\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '  function name() external view returns (string memory);\n', '  function symbol() external view returns (string memory);\n', '  function decimals() external view returns (uint8);\n', '  function totalSupply() external view returns (uint);\n', '  function balanceOf(address owner) external view returns (uint);\n', '  function allowance(address owner, address spender) external view returns (uint);\n', '\n', '  function approve(address spender, uint value) external returns (bool);\n', '  function transfer(address to, uint value) external returns (bool);\n', '  function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', 'interface IMistXJar {\n', '  function deposit() external payable;\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', 'interface IUniswapRouter {\n', '  function WETH() external view returns (address);\n', '\n', '  function addLiquidity(\n', '    address tokenA,\n', '    address tokenB,\n', '    uint256 amountADesired,\n', '    uint256 amountBDesired,\n', '    uint256 amountAMin,\n', '    uint256 amountBMin,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (\n', '    uint256 amountA,\n', '    uint256 amountB,\n', '    uint256 liquidity\n', '  );\n', '\n', '  function addLiquidityETH(\n', '    address token,\n', '    uint256 amountTokenDesired,\n', '    uint256 amountTokenMin,\n', '    uint256 amountETHMin,\n', '    address to,\n', '    uint256 deadline\n', '  ) external payable returns (\n', '    uint256 amountToken,\n', '    uint256 amountETH,\n', '    uint256 liquidity\n', '  );\n', '\n', '  function factory() external view returns (address);\n', '\n', '  function getAmountIn(\n', '    uint256 amountOut,\n', '    uint256 reserveIn,\n', '    uint256 reserveOut\n', '  ) external pure returns (uint256 amountIn);\n', '\n', '  function getAmountOut(\n', '    uint256 amountIn,\n', '    uint256 reserveIn,\n', '    uint256 reserveOut\n', '  ) external pure returns (uint256 amountOut);\n', '\n', '  function getAmountsIn(\n', '    uint256 amountOut,\n', '    address[] memory path\n', '  ) external view returns (uint256[] memory amounts);\n', '\n', '  function getAmountsOut(\n', '    uint256 amountIn,\n', '    address[] memory path\n', '  ) external view returns (uint256[] memory amounts);\n', '\n', '  function quote(\n', '    uint256 amountA,\n', '    uint256 reserveA,\n', '    uint256 reserveB\n', '  ) external pure returns (uint256 amountB);\n', '\n', '  function removeLiquidity(\n', '    address tokenA,\n', '    address tokenB,\n', '    uint256 liquidity,\n', '    uint256 amountAMin,\n', '    uint256 amountBMin,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '  function removeLiquidityETH(\n', '    address token,\n', '    uint256 liquidity,\n', '    uint256 amountTokenMin,\n', '    uint256 amountETHMin,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '  function removeLiquidityETHWithPermit(\n', '    address token,\n', '    uint256 liquidity,\n', '    uint256 amountTokenMin,\n', '    uint256 amountETHMin,\n', '    address to,\n', '    uint256 deadline,\n', '    bool approveMax,\n', '    uint8 v,\n', '    bytes32 r,\n', '    bytes32 s\n', '  ) external returns (uint256 amountToken, uint256 amountETH);\n', '\n', '  function removeLiquidityWithPermit(\n', '    address tokenA,\n', '    address tokenB,\n', '    uint256 liquidity,\n', '    uint256 amountAMin,\n', '    uint256 amountBMin,\n', '    address to,\n', '    uint256 deadline,\n', '    bool approveMax,\n', '    uint8 v,\n', '    bytes32 r,\n', '    bytes32 s\n', '  ) external returns (uint256 amountA, uint256 amountB);\n', '\n', '  function swapETHForExactTokens(\n', '    uint256 amountOut,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external payable returns (uint256[] memory amounts);\n', '\n', '  function swapExactETHForTokens(\n', '    uint256 amountOutMin,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external payable returns (uint256[] memory amounts);\n', '\n', '  function swapExactTokensForETH(\n', '    uint256 amountIn,\n', '    uint256 amountOutMin,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256[] memory amounts);\n', '\n', '  function swapExactTokensForTokens(\n', '    uint256 amountIn,\n', '    uint256 amountOutMin,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256[] memory amounts);\n', '\n', '  function swapTokensForExactETH(\n', '    uint256 amountOut,\n', '    uint256 amountInMax,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256[] memory amounts);\n', '\n', '  function swapTokensForExactTokens(\n', '    uint256 amountOut,\n', '    uint256 amountInMax,\n', '    address[] memory path,\n', '    address to,\n', '    uint256 deadline\n', '  ) external returns (uint256[] memory amounts);\n', '\n', '  function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '    uint amountIn,\n', '    uint amountOutMin,\n', '    address[] calldata path,\n', '    address to,\n', '    uint deadline\n', '  ) external;\n', '\n', '  function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '    uint amountOutMin,\n', '    address[] calldata path,\n', '    address to,\n', '    uint deadline\n', '  ) external payable;\n', '\n', '  function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '    uint amountIn,\n', '    uint amountOutMin,\n', '    address[] calldata path,\n', '    address to,\n', '    uint deadline\n', '  ) external;\n', '\n', '  receive() external payable;\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', 'import "../interfaces/IERC20.sol";\n', 'import "./Address.sol";\n', '\n', '\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        require((value == 0) || (token.allowance(address(this), spender) == 0),\n', '            "SafeERC20: approve from non-zero to non-zero allowance"\n', '        );\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) + value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender) - value;\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) {\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.8.3;\n', '\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']