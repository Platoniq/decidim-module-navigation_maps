export default (tabsContainerId) => {
  // store tabs variable
  const tabs = document.querySelectorAll(`#${tabsContainerId} ul.nav-tabs > li`);
  const changeTab = (tabClickEvent) => {
    for (let idx = 0; idx < tabs.length; idx += 1) {
      tabs[idx].classList.remove("is-active");
    }
    const clickedTab = tabClickEvent.currentTarget;
    clickedTab.classList.add("is-active");
    tabClickEvent.preventDefault();
    const myContentPanes = document.querySelectorAll(".tab-pane");
    for (let idx = 0; idx < myContentPanes.length; idx += 1) {
      myContentPanes[idx].classList.remove("is-active");
    }
    const anchorReference = tabClickEvent.target;
    const activePaneId = anchorReference.getAttribute("href");
    const activePane = document.querySelector(activePaneId);
    activePane.classList.add("is-active");
  };
  for (let idx = 0; idx < tabs.length; idx += 1) {
    tabs[idx].addEventListener("click", changeTab)
  }
};
