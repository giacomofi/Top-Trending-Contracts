['pragma solidity ^0.4.7;\n', 'contract TheEthereumLottery {\n', ' /*\n', '    Brief introduction:\n', '    \n', '    To play you need to pick 4 numbers (range 0-255) and provide them sorted to Play() function.\n', '    To win you need to hit at least 1 number out of 4 WinningNums which will be announced once every week\n', '    (or more often if the lottery will become more popular). If you hit all of the 4 numbers you will win\n', '    about 10 million times more than you payed for lottery ticket. The exact values are provided as GuessXOutOf4\n', '    entries in Ledger - notice that they are provided in Wei, not Ether (10^18 Wei = Ether).\n', '    Use Withdraw() function to pay out.\n', '\n', '\n', '    The advantage of TheEthereumLottery is that it uses secret random value which only owner knows (called TheRand).\n', '    A hash of TheRand (called OpeningHash) is announced at the beginning of every draw (lets say draw number N) - \n', '    at this moment ticket price and the values of GuessXOutOf4 are publicly available and can not be changed.\n', '    When draw N+1 is announced in a block X, a hash of block X-1 is assigned to ClosingHash field of draw N.\n', '    After few minutes, owner announces TheRand which satisfy following expression: sha3(TheRand)==drawN.OpeningHash\n', '    then Rand32B=sha3(TheRand, ClosingHash) is calculated an treated as a source for WinningNumbers, \n', '    also ClosingHash is changed to Rand32B as it might be more interesting for someone watching lottery ledger\n', '    to see that number instead of hash of some block. \n', '\n', '    This approach (1) unable players to cheat, as as long as no one knows TheRand, \n', '    no one can predict what WinningNums will be, (2) unable owner to influence the WinningNums (in order to\n', '    reduce average amount won) because OpeningHash=sha3(TheRand) was public before bets were made, and (3) reduces \n', "    owner capability of playing it's own lottery and making winning bets to very short window of one\n", '    exactly the same block as new draw was announced - so anyone, with big probability, can think that if winning\n', '    bet was made in this particular block - probably it was the owner, especially if no more bets were made \n', '    at this block (which is very likely).\n', '\n', '    Withdraw is possible only after TheRand was announced, if the owner will not announce TheRand in 2 weeks,\n', '    players can use Refund function in order to refund their ETH used to make bet. \n', '    That moment is called ExpirationTime on contract Ledger (which is visible from JSON interface).\n', ' */\n', '/*\n', '  Name:\n', '  TheEthereumLottery\n', '\n', '  JSON interface:\n', '\n', '[{"constant":true,"inputs":[],"name":"Announcements","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"IndexOfCurrentDraw","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"ledger","outputs":[{"name":"WinningNum1","type":"uint8"},{"name":"WinningNum2","type":"uint8"},{"name":"WinningNum3","type":"uint8"},{"name":"WinningNum4","type":"uint8"},{"name":"ClosingHash","type":"bytes32"},{"name":"OpeningHash","type":"bytes32"},{"name":"Guess4OutOf4","type":"uint256"},{"name":"Guess3OutOf4","type":"uint256"},{"name":"Guess2OutOf4","type":"uint256"},{"name":"Guess1OutOf4","type":"uint256"},{"name":"PriceOfTicket","type":"uint256"},{"name":"ExpirationTime","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"TheRand","type":"bytes32"}],"name":"CheckHash","outputs":[{"name":"OpeningHash","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"DrawIndex","type":"uint8"},{"name":"PlayerAddress","type":"address"}],"name":"MyBet","outputs":[{"name":"Nums","type":"uint8[4]"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"referral_fee","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"referral_ledger","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"MyNum1","type":"uint8"},{"name":"MyNum2","type":"uint8"},{"name":"MyNum3","type":"uint8"},{"name":"MyNum4","type":"uint8"}],"name":"Play","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"DrawIndex","type":"uint32"}],"name":"Withdraw","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"DrawIndex","type":"uint32"}],"name":"Refund","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"MyNum1","type":"uint8"},{"name":"MyNum2","type":"uint8"},{"name":"MyNum3","type":"uint8"},{"name":"MyNum4","type":"uint8"},{"name":"ref","type":"address"}],"name":"PlayReferred","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"Withdraw_referral","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"Deposit_referral","outputs":[],"payable":true,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint256"},{"indexed":false,"name":"OpeningHash","type":"bytes32"},{"indexed":false,"name":"PriceOfTicketInWei","type":"uint256"},{"indexed":false,"name":"WeiToWin","type":"uint256"}],"name":"NewDrawReadyToPlay","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"IndexOfDraw","type":"uint32"},{"indexed":false,"name":"WinningNumber1","type":"uint8"},{"indexed":false,"name":"WinningNumber2","type":"uint8"},{"indexed":false,"name":"WinningNumber3","type":"uint8"},{"indexed":false,"name":"WinningNumber4","type":"uint8"},{"indexed":false,"name":"TheRand","type":"bytes32"}],"name":"DrawReadyToPayout","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"Wei","type":"uint256"}],"name":"PlayerWon","type":"event"}]\n', '\n', '*/\n', '//constructor\n', 'function TheEthereumLottery()\n', '{\n', '  owner=msg.sender;\n', '  ledger.length=0;\n', '  IndexOfCurrentDraw=0;\n', '  referral_fee=90;\n', '}\n', 'modifier OnlyOwner()\n', '{ // Modifier\n', '  if (msg.sender != owner) throw;\n', '  _;\n', '}\n', 'address owner;\n', 'string public Announcements;//just additional feature\n', 'uint public IndexOfCurrentDraw;//starting from 0\n', 'uint8 public referral_fee;\n', 'mapping(address=>uint256) public referral_ledger;\n', 'struct bet_t {\n', '  address referral;\n', '  uint8[4] Nums;\n', '  bool can_withdraw;//default==false\n', '}\n', 'struct ledger_t {\n', '  uint8 WinningNum1;\n', '  uint8 WinningNum2;\n', '  uint8 WinningNum3;\n', '  uint8 WinningNum4;\n', '  bytes32 ClosingHash;\n', '  bytes32 OpeningHash;\n', '  mapping(address=>bet_t) bets;\n', '  uint Guess4OutOf4;\n', '  uint Guess3OutOf4;\n', '  uint Guess2OutOf4;\n', '  uint Guess1OutOf4;\n', '  uint PriceOfTicket;\n', '  uint ExpirationTime;//for eventual refunds only, ~2 weeks after draw announced\n', '}\n', 'ledger_t[] public ledger;\n', ' \n', '//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', '//@@@@@@@@@@@ Here begins what probably you want to analyze @@@@@@@@@@@@\n', '//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', 'function next_draw(bytes32 new_hash,\n', '\t  uint priceofticket,\n', '\t  uint guess4outof4,\n', '\t  uint guess3outof4,\n', '\t  uint guess2outof4,\n', '\t  uint guess1outof4\n', '\t  )\n', 'OnlyOwner\n', '{\n', '  ledger.length++;\n', '  ledger[IndexOfCurrentDraw].ClosingHash =\n', '    //sha3(block.blockhash(block.number-1));               //this, or\n', '    //sha3(block.blockhash(block.number-1),block.coinbase);//this adds complexity, but safety remains the same\n', '    block.blockhash(block.number-1);//adds noise to the previous draw\n', '  //if you are just checking how it works, just pass the comment below, and come back when you finish analyzing\n', '  //the contract - it explains how the owner could win this lottery \n', '  //if the owner was about to cheat, he has to make a bet, and then use this f-n. both in a single block.\n', '  //its because if you know TheRand and blockhash of a last block before new draw then you can determine the numbers\n', '  //achieving it would be actually simple, another contract is needed which would get signed owner tx of this f-n call\n', '  //and just calculate what the numbers would be (the previous block hash is available), play with that nums,\n', '  //and then run this f-n. It is guaranteed that both actions are made in a single block, as it is a single call\n', '  //so if someone have made winning bet in exactly the same block as announcement of next draw,\n', '  //then you can be suspicious that it was the owner\n', '  //also assuming this scenario, TheRand needs to be present on that contract - so if transaction is not mined\n', '  //immediately - it makes a window for anyone to do the same and win.\n', '  IndexOfCurrentDraw=ledger.length-1;\n', '  ledger[IndexOfCurrentDraw].OpeningHash = new_hash;\n', '  ledger[IndexOfCurrentDraw].Guess4OutOf4=guess4outof4;\n', '  ledger[IndexOfCurrentDraw].Guess3OutOf4=guess3outof4;\n', '  ledger[IndexOfCurrentDraw].Guess2OutOf4=guess2outof4;\n', '  ledger[IndexOfCurrentDraw].Guess1OutOf4=guess1outof4;\n', '  ledger[IndexOfCurrentDraw].PriceOfTicket=priceofticket;\n', '  ledger[IndexOfCurrentDraw].ExpirationTime=now + 2 weeks;//You can refund after ExpirationTime if owner will not announce TheRand satisfying TheHash\n', '  NewDrawReadyToPlay(IndexOfCurrentDraw, new_hash, priceofticket, guess4outof4);//event\n', '}\n', 'function announce_therand(uint32 index,\n', '\t\t\t  bytes32 the_rand\n', '\t\t\t  )\n', 'OnlyOwner\n', '{\n', '  if(sha3(the_rand)\n', '     !=\n', '     ledger[index].OpeningHash)\n', '    throw;//this implies that if Numbers are present, broadcasted TheRand has to satisfy TheHash\n', '\n', '\n', "  bytes32 combined_rand=sha3(the_rand, ledger[index].ClosingHash);//from this number we'll calculate WinningNums\n", '  //usually the last 4 Bytes will be the WinningNumbers, but it is not always true, as some Byte could\n', '  //be the same, then we need to take one more Byte from combined_rand and so on\n', '\n', '  ledger[index].ClosingHash = combined_rand;//changes the closing blockhash to seed for WinningNums\n', '    //this line is useless from the perspective of lottery\n', '    //but maybe some of the players will find it interesting that something\n', '    //which is connected to the WinningNums is present in a ledger\n', '\n', '\n', '  //the algorithm of assigning an int from some range to single bet takes too much code\n', '  uint8[4] memory Numbers;//relying on that combined_rand should be random - lets pick Nums into this array \n', '\n', '  uint8 i=0;//i = how many numbers are picked\n', '  while(i<4)\n', '    {\n', "      Numbers[i]=uint8(combined_rand);//same as '=combined_rand%256;'\n", '      combined_rand>>=8;//same as combined_rand/=256;\n', '      for(uint j=0;j<i;++j)//is newly picked val in a set?\n', '\tif(Numbers[j]==Numbers[i]) {--i;break;}//yes, break back to while loop and look for another Num[i]\n', '      ++i;\n', '    }\n', '  //probability that in 32 random bytes there was only 3 or less different ones ~=2.65e-55\n', "  //it's like winning this lottery 2.16*10^46 times in a row\n", '  //p.s. there are 174792640 possible combinations of picking 4 numbers out of 256\n', '\n', '  //now we have to sort the values\n', '  for(uint8 n=4;n>1;n--)//bubble sort\n', '    {\n', '      bool sorted=true; \n', '      for(uint8 k=0;k<n-1;++k)\n', '\tif(Numbers[k] > Numbers[k+1])//then mark array as not sorted & swap\n', '\t  {\n', '\t    sorted=false;\n', '\t    (Numbers[k], Numbers[k+1])=(Numbers[k+1], Numbers[k]);\n', '\t  }\n', '      if(sorted) break;//breaks as soon as the array is sorted\n', '    }\n', '\n', '  \n', '  ledger[index].WinningNum1 = Numbers[0];\n', '  ledger[index].WinningNum2 = Numbers[1];\n', '  ledger[index].WinningNum3 = Numbers[2];\n', '  ledger[index].WinningNum4 = Numbers[3];\n', '  \n', '  DrawReadyToPayout(index,\n', '\t\t    Numbers[0],Numbers[1],Numbers[2],Numbers[3],\n', '\t\t    the_rand);//event\n', '}\n', '\n', 'function PlayReferred(uint8 MyNum1,\n', '\t\t      uint8 MyNum2,\n', '\t\t      uint8 MyNum3,\n', '\t\t      uint8 MyNum4,\n', '\t\t      address ref\n', '\t\t      )\n', 'payable\n', '{\n', '  if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket ||//to play you need to pay \n', '     ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3] != 0)//if your bet already exist\n', '    throw;\n', '\n', '  //if numbers are not sorted\n', '  if(MyNum1 >= MyNum2 ||\n', '     MyNum2 >= MyNum3 ||\n', '     MyNum3 >= MyNum4\n', '     )\n', '    throw;//because you should sort the values yourself\n', '  if(ref!=0)//when there is no refferal, function is cheaper for ~20k gas\n', '    ledger[IndexOfCurrentDraw].bets[msg.sender].referral=ref;\n', '  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[0]=MyNum1;\n', '  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[1]=MyNum2;\n', '  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[2]=MyNum3;\n', '  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3]=MyNum4;\n', '  ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;\n', '}\n', '// Play wrapper:\n', 'function Play(uint8 MyNum1,\n', '\t      uint8 MyNum2,\n', '\t      uint8 MyNum3,\n', '\t      uint8 MyNum4\n', '\t      )\n', '{\n', '  PlayReferred(MyNum1,\n', '\t       MyNum2,\n', '\t       MyNum3,\n', '\t       MyNum4,\n', '\t       0//no referral\n', '\t       );\n', '}\n', 'function Deposit_referral()//this function is not mandatory to become referral\n', '  payable//might be used to not withdraw all the funds at once or to invest\n', '{//probably needed only at the beginnings\n', '  referral_ledger[msg.sender]+=msg.value;\n', '}\n', 'function Withdraw_referral()\n', '{\n', '  uint val=referral_ledger[msg.sender];\n', '  referral_ledger[msg.sender]=0;\n', '  if(!msg.sender.send(val)) //payment\n', '    throw;\n', '}\n', 'function set_referral_fee(uint8 new_fee)\n', 'OnlyOwner\n', '{\n', '  if(new_fee<50 || new_fee>100)\n', '    throw;//referrals have at least 50% of the income\n', '  referral_fee=new_fee;\n', '}\n', 'function Withdraw(uint32 DrawIndex)\n', '{\n', '  //if(msg.value!=0) //compiler deals with that, as there is no payable modifier in this f-n\n', '  //  throw;//this function is free\n', '\n', '  if(ledger[DrawIndex].bets[msg.sender].can_withdraw==false)\n', '    throw;//throw if player didnt played\n', '\n', '  //by default, every non existing value is equal to 0\n', '  //so if there was no announcement WinningNums are zeros\n', '  if(ledger[DrawIndex].WinningNum4 == 0)//the least possible value == 3\n', '    throw;//this condition checks if the numbers were announced\n', '  //see announce_therand f-n to see why this check is enough\n', '  \n', '  uint8 hits=0;\n', '  uint8 i=0;\n', '  uint8 j=0;\n', '  uint8[4] memory playernum=ledger[DrawIndex].bets[msg.sender].Nums;\n', '  uint8[4] memory nums;\n', '  (nums[0],nums[1],nums[2],nums[3])=\n', '    (ledger[DrawIndex].WinningNum1,\n', '     ledger[DrawIndex].WinningNum2,\n', '     ledger[DrawIndex].WinningNum3,\n', '     ledger[DrawIndex].WinningNum4);\n', '  //data ready\n', '  \n', '  while(i<4)//count player hits\n', '    {//both arrays are sorted\n', '      while(j<4 && playernum[j] < nums[i]) ++j;\n', '      if(j==4) break;//nothing more to check - break loop here\n', '      if(playernum[j] == nums[i]) ++hits;\n', '      ++i;\n', '    }\n', '  if(hits==0) throw;\n', '  uint256 win=0;\n', '  if(hits==1) win=ledger[DrawIndex].Guess1OutOf4;\n', '  if(hits==2) win=ledger[DrawIndex].Guess2OutOf4;\n', '  if(hits==3) win=ledger[DrawIndex].Guess3OutOf4;\n', '  if(hits==4) win=ledger[DrawIndex].Guess4OutOf4;\n', '    \n', '  ledger[DrawIndex].bets[msg.sender].can_withdraw=false;\n', '  if(!msg.sender.send(win)) //payment\n', '    throw;\n', '\n', '  if(ledger[DrawIndex].bets[msg.sender].referral==0)//it was not referred bet\n', '    referral_ledger[owner]+=win/100;\n', '  else\n', '    {\n', '      referral_ledger[ledger[DrawIndex].bets[msg.sender].referral]+=\n', '\twin/10000*referral_fee;//(win/100)*(referral_fee/100);\n', '      referral_ledger[owner]+=\n', '\twin/10000*(100-referral_fee);//(win/100)*((100-referral_fee)/100);\n', '    }\n', '\n', '  \n', '  PlayerWon(win);//event\n', '}\n', 'function Refund(uint32 DrawIndex)\n', '{\n', '  //if(msg.value!=0) //compiler deals with that, as there is no payable modifier in this f-n\n', '  //  throw;//this function is free\n', '\n', '  if(ledger[DrawIndex].WinningNum4 != 0)//if TheRand was announced, WinningNum4 >= 3\n', '    throw; //no refund if there was a valid announce\n', '\n', '  if(now < ledger[DrawIndex].ExpirationTime)\n', '    throw;//no refund while there is still TIME to announce TheRand\n', '  \n', ' \n', '  if(ledger[DrawIndex].bets[msg.sender].can_withdraw==false)\n', '    throw;//throw if player didnt played or already refunded\n', '  \n', '  ledger[DrawIndex].bets[msg.sender].can_withdraw=false;\n', '  if(!msg.sender.send(ledger[DrawIndex].PriceOfTicket)) //refund\n', '    throw;\n', '}\n', '//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', '//@@@@@@@@@@@ Here ends what probably you wanted to analyze @@@@@@@@@@@@\n', '//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', '\n', 'function CheckHash(bytes32 TheRand)\n', '  constant returns(bytes32 OpeningHash)\n', '{\n', '  return sha3(TheRand);\n', '}\n', 'function MyBet(uint8 DrawIndex, address PlayerAddress)\n', '  constant returns (uint8[4] Nums)\n', '{//check your nums\n', '  return ledger[DrawIndex].bets[PlayerAddress].Nums;\n', '}\n', 'function announce(string MSG)\n', '  OnlyOwner\n', '{\n', '  Announcements=MSG;\n', '}\n', 'event NewDrawReadyToPlay(uint indexed IndexOfDraw,\n', '\t\t\t bytes32 OpeningHash,\n', '\t\t\t uint PriceOfTicketInWei,\n', '\t\t\t uint WeiToWin);\n', 'event DrawReadyToPayout(uint32 indexed IndexOfDraw,\n', '\t\t\tuint8 WinningNumber1,\n', '\t\t\tuint8 WinningNumber2,\n', '\t\t\tuint8 WinningNumber3,\n', '\t\t\tuint8 WinningNumber4,\n', '\t\t\tbytes32 TheRand);\n', 'event PlayerWon(uint Wei);\n', '\n', '}//contract']