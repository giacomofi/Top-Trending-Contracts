['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address account) external view returns (uint256);\n', '}\n', '\n', 'contract xPpayExchangeRate {\n', '  IERC20 private immutable xPpay;\n', '  IERC20 private immutable ppay;\n', '\n', '  constructor(address _xPpay, address _ppay) {\n', '    xPpay = IERC20(_xPpay);\n', '    ppay = IERC20(_ppay);\n', '  }\n', '\n', '  function getExchangeRate() public view returns( uint256 ) {\n', '    return ppay.balanceOf(address(xPpay))*(1e18) / xPpay.totalSupply();\n', '  }\n', '  \n', '  function toPPAY(uint256 xPpayAmount) public view returns (uint256 ppayAmount) {\n', '    ppayAmount = xPpayAmount * ppay.balanceOf(address(xPpay)) / xPpay.totalSupply();\n', '  }\n', '  \n', '  function toXPPAY(uint256 ppayAmount) public view returns (uint256 xPpayAmount) {\n', '    xPpayAmount = ppayAmount * xPpay.totalSupply() / ppay.balanceOf(address(xPpay));\n', '  }\n', '}']