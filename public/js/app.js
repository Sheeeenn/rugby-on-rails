document.addEventListener('DOMContentLoaded', () => {
  const { createApp, ref, computed } = Vue;
  
  createApp({
    setup() {
      const searchQuery = ref('');
      const selectedTags = ref([]);
      
      const toggleTag = (tag) => {
        const index = selectedTags.value.indexOf(tag);
        if (index === -1) {
          selectedTags.value.push(tag);
        } else {
          selectedTags.value.splice(index, 1);
        }
      };
      
      const removeTag = (index) => {
        selectedTags.value.splice(index, 1);
      };
      
      const isTagSelected = (tag) => {
        return selectedTags.value.includes(tag);
      };
      
      const performSearch = () => {
        if (searchQuery.value.trim() || selectedTags.value.length > 0) {
          console.log('Searching for:', {
            query: searchQuery.value,
            tags: selectedTags.value
          });
          // Here you would typically make an API call or filter results
        }
      };
      
      return {
        searchQuery,
        selectedTags,
        toggleTag,
        removeTag,
        isTagSelected,
        performSearch
      };
    }
  }).mount('#app');
});
