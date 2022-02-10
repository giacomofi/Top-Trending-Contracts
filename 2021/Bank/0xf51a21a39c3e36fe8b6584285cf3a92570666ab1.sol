['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address internal _owner;\n', '\n', '    constructor() {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function WETH() external pure returns (address);\n', '}\n', '\n', 'contract TokenBuyBackBurn is Ownable {\n', '\n', '    IUniswapV2Router02 private uniswapV2Router;\n', '    address public token;\n', '    address public burnAddress;\n', '    mapping(address => bool) authorized;    \n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '    \n', '    modifier onlyAuthorized() {\n', '        require(authorized[address(msg.sender)], "Not Authroized");\n', '        _;\n', '    }\n', '\n', '    constructor () {\n', '        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        uniswapV2Router = _uniswapV2Router;\n', '        burnAddress = 0x000000000000000000000000000000000000dEaD;\n', '        authorized[address(_owner)] = true;\n', '    }\n', '\n', '    function setToken(address _token) external onlyOwner {\n', '        token = _token;\n', '    }\n', '\n', '    function setAuthorized(address _address, bool _bool) external onlyOwner {\n', '        authorized[address(_address)] = _bool;\n', '    }\n', '\n', '    function buyBackAndBurn() external onlyAuthorized {\n', '        uint ethBalance = address(this).balance;\n', '        swapETHForToken(ethBalance);\n', '    }\n', '    \n', '    function swapETHForToken(uint ethAmount) private {\n', '        address[] memory path = new address[](2);\n', '        path[0] = uniswapV2Router.WETH();\n', '        path[1] = address(token);\n', '\n', '        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(ethAmount,path,address(burnAddress),block.timestamp);\n', '    }\n', '\n', '    receive() external payable {}\n', '}']