const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  // how is hre imported? everytime npx hardhat, you're getting the hre object built on the fly usin the hardhat.confi.js
  const joinSpaceFactory = await hre.ethers.getContractFactory("JoinSpace"); // compiles our contract, and generates neccessary files in artifact director
  const joinSpaceContract = await joinSpaceFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  }); // hard hat will create a new local etheeum network for us, but only for this contract.After, script complete it will be destroyed. so, everytime we run our contract, it's run on fresh blockchain
  await joinSpaceContract.deployed(); // wait utill our contract is deployed

  console.log("Contract deployed to: ", joinSpaceContract.address);
  console.log("Contract deployed by", owner.address);

  console.log("rand person", randomPerson.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    joinSpaceContract.address
  );
  console.log(
    "Contract balance",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let totalSpacers;
  totalSpacers = await joinSpaceContract.getTotalSpacers(); // we're not waitin for it like one below, cause it's view function i.e doesn't change state of deve

  const PENDING = hre.ethers.BigNumber.from("0"); // PENDING
  const NOT_DETERMINED = hre.ethers.BigNumber.from("2"); // NOT_DETERMINED

  let joinSpaceTx = await joinSpaceContract.joinSpace({
    id: owner.address,
    feelingEmoji: "happy", // figure how u can store feelin emojis
    countryEmoji: "ET",
    date: "Aug 19, 2022 at 6:40 PM",
    status: PENDING,
    winType: NOT_DETERMINED,
  });
  await joinSpaceTx.wait(); // i think we're waiting for it because, and this function changes state of the blockchain

  totalSpacers = await joinSpaceContract.getTotalSpacers();
  contractBalance = await hre.ethers.provider.getBalance(
    joinSpaceContract.address
  );

  console.log(
    "Contract balance",
    hre.ethers.utils.formatEther(contractBalance)
  );
  // add other persons to wave, (in our case we're gettin a random address, and using that to mimic other people waving)
  let joinSpaceTx2 = await joinSpaceContract.connect(randomPerson).joinSpace({
    id: randomPerson.address,
    feelingEmoji: "happy", // figure how u can store f eelin emojis
    countryEmoji: "US",
    date: "Aug 19, 2022 at 6:40 PM",
    status: PENDING,
    winType: NOT_DETERMINED,
  });
  await joinSpaceTx2.wait();

  totalSpacers = await joinSpaceContract.getTotalSpacers();
  contractBalance = await hre.ethers.provider.getBalance(
    joinSpaceContract.address
  );

  console.log(
    "Contract balance",
    hre.ethers.utils.formatEther(contractBalance)
  );
  const spacersArray = await joinSpaceContract.getSpacersArray();
  // console.log("spacers array ", spacersArray);

  // listen to the event (not sure)
  //   joinSpaceContract.on("NewSpacer", (setter, newSpacer) => {
  //     console.log("New Spacer is ", newSpacer);
  //   });
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // exit node process without error
  } catch (error) {
    console.log(error);
    process.exit(1); // exit node process while indicatin 'Uncaught fatal exception' error
  }
};

runMain();
