['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-08\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', 'interface I{\n', '\tfunction getPair(address t, address t1) external view returns(address pair);\n', '\tfunction createPair(address t, address t1) external returns(address pair);\n', '\tfunction init(uint Eth,address pair) external;\n', '\tfunction deposit() external payable;\n', '\tfunction transfer(address to, uint value) external returns(bool);\n', '\tfunction mint(address to) external returns(uint liquidity);\n', '}\n', '\n', '\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', '// Author: Sam Porter\n', "// With LGE it's now possible to create fairer distribution and fund promising projects without VC vultures at all.\n", '// Non-upgradeable, not owned, liquidity is being created automatically on first transaction after last block of LGE.\n', "// Founders' liquidity is not locked, instead an incentive to keep it is introduced.\n", '// The Event lasts for ~2 months to ensure fair distribution.\n', '// 0,5% of contributed Eth goes to developer for earliest development expenses including audits and bug bounties.\n', '// Blockchain needs no VCs, no authorities.\n', '\n', '//import "./I.sol";\n', '\n', 'contract FoundingEvent {\n', '\tmapping(address => uint) public contributions;\n', '\taddress payable private _deployer;\n', '\tuint88 private _phase;\n', '\tbool private _lgeOngoing;\n', '\taddress private _staking;\n', '\tuint88 private _ETHDeposited;\n', '\tbool private _notInit;\n', '\n', '\tconstructor() {_deployer = msg.sender;_notInit = true;_lgeOngoing = true;}\n', '\tfunction init(address c) public {require(msg.sender == _deployer && _notInit == true);delete _notInit; _staking = c;}\n', '\n', '\tfunction depositEth() external payable {\n', '\t\trequire(_lgeOngoing == true);\n', '\t\tuint amount = msg.value;\n', '\t\tif (block.number >= 12550000) {\n', '\t\t\tuint phase = _phase;\n', '\t\t\tif (phase > 0) {_ETHDeposited += uint88(amount);}\n', '\t\t\tif(block.number >= phase+12550000){_phase = uint88(phase + 10000);_createLiquidity(phase);}\n', '\t\t}\n', "\t\tuint deployerShare = amount/100; amount -= deployerShare; _deployer.transfer(deployerShare);// advertising cancelled as long as there won't be any fork\n", '\t\tcontributions[msg.sender] += amount;\n', '\t}\n', '\n', '\tfunction _createLiquidity(uint phase) internal {\n', '\t\taddress WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '\t\taddress token = 0xdff92dCc99150Df99D54BC3291bD7e5522bB1Edd;// hardcoded token address after erc20 will be deployed\n', '\t\taddress staking = _staking;\n', '\t\taddress factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;\n', '\t\taddress tknETHLP = I(factory).getPair(token,WETH);\n', '\t\tif (phase == 0) {\n', '\t\t\t_ETHDeposited = uint88(address(this).balance);\n', '\t\t\tif (tknETHLP == address(0)) {tknETHLP=I(factory).createPair(token, WETH);require(tknETHLP != address(0));}\n', '\t\t}\n', '\t\tuint ETHDeposited = _ETHDeposited;\n', '\t\tuint ethToDeposit = ETHDeposited*3/5;\n', '\t\tuint tokenToDeposit = 1e23;\n', '\t\tif (phase == 90000) {\n', '\t\t\tethToDeposit = address(this).balance; I(staking).init(ETHDeposited, tknETHLP);\n', '\t\t\tdelete _staking; delete _lgeOngoing; delete _ETHDeposited; delete _phase; delete _deployer;\n', '\t\t}\n', '\t\tI(WETH).deposit{value: ethToDeposit}();\n', '\t\tI(token).transfer(tknETHLP, tokenToDeposit);\n', '\t\tI(WETH).transfer(tknETHLP, ethToDeposit);\n', '\t\tI(tknETHLP).mint(staking);\n', '\t}\n', '}']